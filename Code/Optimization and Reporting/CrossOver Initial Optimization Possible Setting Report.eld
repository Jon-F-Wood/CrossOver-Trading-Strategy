//Data1 = Shorter Timeframe Bid
//Data2 = Shorter Timeframe Ask
//Data3 = Longer Timeframe Bid
//Data4 = Longer Timeframe Ask

Inputs:  
	StartingAccountSize(100000),
	PercentDrawdown(25),
	JL1(36),		   	 	   	  //Length of JumpLine 1 (Typically is JL1 < JL2)
	JL2(34), 			      //Length of JumpLine 2 (Typically is JL2 > JL1)
	CloseCancelsCross(0),	  //A filter that if activated cancels a trade if the price closes in the oposite direction of the trade's side of JL2. 1/On : 0/Off 	
	UseJLCDFilter(0),
	JLCDLength(5),
	TargetLength(3), 	  	  //High + ((High - Low) * Tgt) = The Price that the Target is Placed
	BreakevenTarget(1),    	  //High + ((High - Low) * BreakevenTarget) = The Price Where the StopLoss is moved up to Breakeven
	TrailingJL(7),		   	  //JL used for Trailing
	TrailingTarget(1),        //The Point at which the trade begins to trail
	TrailingOffSetTics(0),    //How Many ticks Below the MA the Stop is Trailed	
	EntryOffsetTics(20),      //High + (EntryOffsetTics/PriceScale) = the Price where the Entry is Placed
	StopOffsetTics(10),       //Low - (StopOffsetTIcs/PriceScale) = The Price where the StopLoss is Placed	
	UseRiskFilter(1),		  //Used to Turn on and Off the Risk Filter.  1/On : 0/Off
	MaxTicsRisk(1000),		  //Maximum tics risk for a trade to be considered valid
	MinTicsRisk(0);		  //Minimum tics risk for a trade to be considered valid
	
Variables:
	_JL1(0), 				   //JumpLine1 (Tenkan-Sen)
	_JL2(0), 				   //JumpLine2	(Tenkan-Sen)
	_TrailingJL(0),			   //JumpLine used for trailing
		
	TheEntryPriceS(0),		   //Holds the Entry Price on Currently active Short Orders	
	TheEntryPriceL(0),		   //Holds the Entry Price on Currently active Long Orders	
	
	TheStopPriceS(0),		   //Holds the Stop Price on Currently active Short Orders
	TheStopPriceL(0),		   //Holds the Stop Price on Currently active Long Orders
	
	TheBreakevenTgtS(0),	   //Holds the Breakeven Target Price on Currently active Short Orders	
	TheBreakevenTgtL(0),	   //Holds the Breakeven Target Price on Currently active Long Orders	
	
	TheTrailingTgtS(0),		   //Holds the Trialing Target Price on Currently active Short Orders
	TheTrailingTgtL(0),		   //Holds the Trialing Target Price on Currently active Long Orders
		
	TheTrailingPriceS(0),	   //Holds the Price that the Trailing Stop Should be Placed on Short Orders
	TheTrailingPriceL(0),	   //Holds the Price that the Trailing Stop Should be Placed on Long Orders
	
	TheTargetPriceS(0),		   //Holds the Target Price on Currently active Short Orders
	TheTargetPriceL(0),		   //Holds the Target Price on Currently active Long Orders
	
//Variables used for strategy	
	MP(0),					   //Used to be able to reference MarketPosition Historically
	PipsRiskS(0),
	PipsRiskL(0),
	
//JLCD Filter Variables
	MyJLCD( 0 ),
	JLCDAvg( 0 ),
	JLCDDiff( 0 ),
	
//Variables used for Backtesting
	AccountSize(0),
	EndingAccuracyRate(0),
	MaxNumLosesInARow(0),
	$Risk(0),
	RiskPcentPerTrade(0),
	TradeResult(0),	
	_Spread(0),
	Counter(0),
	WeekendExit(False),
	
//Conditional Variables that Hold thier value until changed by a condition	
	ASetupIsActiveS(False), 	 //This Records if a Short Setup has been Placed or if has been Entered or if it has been cancled
	ASetupIsActiveL(False), 	 //This Records if a Long Setup has been Placed or if has been Entered or if it has been cancled
	
	StopIsAtBrkEvnS(False),      //This Records if a Short Position's Stop is Currenly at Breakeven
	StopIsAtBrkEvnL(False),      //This Records if a Long Position's Stop is Currenly at Breakeven
	
	TrailingIsOnS(False),		 //The Short Trailing Tgt Has been hit
	TrailingIsOnL(False),		 //The Long Trailing Tgt Has been hit
	
	NowTrailingS(False),  	     //Short Position's Stop is Now Trailing
	NowTrailingL(False),  	     //Long Position's Stop is Now Trailing
	
//Conditional Variables that are evaluated bar by bar		
	RedBar(False), 			     //Is the Current Bar an Down(Red) Bar
	GreenBar(False), 			 //Is the Current Bar an Up(Green) Bar	
	
	CloseLessThanJL2(False),     //The Close price of the Current Bar is Lower Than the JL2 Value
	CloseHigherThanJL2(False),   //The Close price of the Current Bar is Higher Than the JL2 Value

	JL1CrossedOverJL2(False),	 //Shows there is a Cross Over and no setup has been activated 
	JL1CrossedUnderJL2(False),	 //Shows there is a Cross Under and no setup has been activated
	
	HasNotEnteredYetS(False),    //The Low of the Current Bar Is Higher Than the Currently Active Short Position's Entry Price (It hasn't Entered Yet)
	HasNotEnteredYetL(False),    //The High of the Current Bar Is Less Than the Currently Active Long Position's Entry Price (It hasn't Entered Yet)	
	
	HasYetToHitStopS(False),     //The High of the Current Bar is Lower than the Currently Active Short Position's Stop Price (It hasn't Stopped Out Yet)
	HasYetToHitStopL(False),     //The Low of the Current Bar is Higher than the Currently Active Long Position's Stop Price (It hasn't Stopped Out Yet)
	
	HasYetToHitBrkEvnS(False),	 //The Low Of the Current Bar is Higher than the Currently Acive Short Position's Breakeven Target (BrkEvn Tgt has yet to be Hit)
	HasYetToHitBrkEvnL(False),	 //The High Of the Current Bar is Lower than the Currently Acive Long Position's Breakeven Target (BrkEvn Tgt has yet to be Hit)
	
	HasYetToHitTrialingS(False), //The Low Of the Current Bar is Higher than the Currently Acive Short Position's Trailing Target (Trailing Tgt has yet to be Hit)
	HasYetToHitTrialingL(False), //The High Of the Current Bar is Lower than the Currently Acive Long Position's Trailing Target (Trailing Tgt has yet to be Hit)
	
	HasYetToHitTargetS(False),   //The Low Of the Current Bar is Higher than the Currently Acive Short Position's Target Price (It hasn't Hit Target Yet)
	HasYetToHitTargetL(False),   //The High Of the Current Bar is Lower than the Currently Acive Long Position's Target Price (It hasn't Hit Target Yet) r
 	
 	CurrentlyInMarketS(False),   //Used to tell whether or not the system is currently in a Short position or not
 	CurrentlyInMarketL(False),   //Used to tell whether or not the system is currently in a Long position or not
 	
 	StageOrder(False);

//Moving Averages	
_JL1 = (Highest(High of Data3, JL1) + Lowest(Low of Data3, JL1))/2 ;
_JL2 = (Highest(High of Data3, JL2) + Lowest(Low of Data3, JL2))/2  ;
_TrailingJL = (Highest(High of Data3, TrailingJL) + Lowest(Low of Data3, TrailingJL))/2  ;
		
//Set the Trailing Price
TheTrailingPriceS = _TrailingJL + (TrailingOffSetTics/PriceScale);
TheTrailingPriceL = _TrailingJL - (TrailingOffSetTics/PriceScale);

MP = Marketposition;

{This Section is used to tell the user what to set MaxBarsBack to 
by displaying a number in the print log that should be rounded 
up to nearest hundred which is what MaxBarsBack should be set to.} 
Array:
	PipsRiskAndResult[6000,1](0), //0 = Pips Risk, 1 = Pips Result
	WinningTrades[](0),
	LosingTrades[](0);

Array_setmaxindex(WinningTrades,6000);
Array_setmaxindex(LosingTrades,6000);

HasNotEnteredYetS = Low > TheEntryPriceS;
HasYetToHitStopS = High < TheStopPriceS;
HasYetToHitTargetS = Low > TheTargetPriceS;
HasYetToHitBrkEvnS = Low > TheBreakevenTgtS;
HasYetToHitTrialingS = Low > TheTrailingTgtS;

HasNotEnteredYetL = High < TheEntryPriceL;
HasYetToHitStopL = Low > TheStopPriceL;
HasYetToHitTargetL = High < TheTargetPriceL;
HasYetToHitBrkEvnL = High < TheBreakevenTgtL;
HasYetToHitTrialingL = High < TheTrailingTgtL;

If MP = 0 and (MP[1] = 1 or MP[1] = -1) and WeekendExit = False then
	Begin		
		If MP[1] = 1 then
			Begin			
				If HasYetToHitTargetL = True then
					Begin	
						If Open < TheStopPriceL then
							Begin
								PipsRiskAndResult[Counter - 1,1] = (Open - (EntryPrice(1) + _Spread))*(PriceScale/10);
							End
						Else
							Begin
								PipsRiskAndResult[Counter - 1,1] = (TheStopPriceL - (EntryPrice(1) + _Spread))*(PriceScale/10);
							End;							
					End
				Else
					Begin
						If Open > TheTargetPriceL then
							Begin
								PipsRiskAndResult[Counter - 1,1] = (Open - (EntryPrice(1) + _Spread))*(PriceScale/10);
							End
						Else
							Begin								
								PipsRiskAndResult[Counter - 1,1] = (TheTargetPriceL - (EntryPrice(1) + _Spread))*(PriceScale/10);
							End;			
					End;
				
				If PipsRiskAndResult[Counter - 1,1] >= 0 or	StopIsAtBrkEvnL[1] = True or (TheStopPriceL = theTrailingPriceL)then
					Begin
						WinningTrades[Counter - 1] = WinningTrades[Counter - 1] + 1;
						LosingTrades[Counter - 1] = 0;
					End
				Else
					Begin
						LosingTrades[Counter - 1] = LosingTrades[Counter - 1] + 1;
						WinningTrades[Counter - 1] = 0;
					End;							
			End;
			
		If MP[1] = -1 then
			Begin	
				If HasYetToHitTargetS = True then
					Begin	
						If Open > TheStopPriceS then
							Begin
								PipsRiskAndResult[Counter - 1,1] = (EntryPrice(1) - (Open + Spread(1)))*(PriceScale/10);
							End
						Else
							Begin
								PipsRiskAndResult[Counter - 1,1] = (EntryPrice(1) - (TheStopPriceS + Spread(1)))*(PriceScale/10);
							End;			
					End
				Else
					Begin
						If Open < TheTargetPriceS then
							Begin
								PipsRiskAndResult[Counter - 1,1] = (EntryPrice(1) - (Open + Spread(1)))*(PriceScale/10);
							End
						Else
							Begin								
								PipsRiskAndResult[Counter - 1,1] = (EntryPrice(1) - (TheTargetPriceS + Spread(1)))*(PriceScale/10);
							End;		
					End;
				
				If PipsRiskAndResult[Counter - 1,1] >= 0 or	StopIsAtBrkEvnS[1] = True or (TheStopPriceS = theTrailingPriceS)then
					Begin
						WinningTrades[Counter - 1] = WinningTrades[Counter - 1] + 1;
						LosingTrades[Counter - 1] = 0;
					End
				Else
					Begin
						LosingTrades[Counter - 1] = LosingTrades[Counter - 1] + 1;
						WinningTrades[Counter - 1] = 0;
					End;				
			End;			
				
		JL1CrossedOverJL2 = False;
		JL1CrossedUnderJL2 = False;
	End;
	
If WeekendExit and MP = 0 and MP[1] <> 0 then
	Begin
		WeekendExit = False;	
		
		If MP[1] = 1 then
			Begin					
				PipsRiskAndResult[Counter - 1,1] = (Open[1] - (EntryPrice(1) + _Spread))*(PriceScale/10);										
			End;
			
		If MP[1] = -1 then
			Begin
				PipsRiskAndResult[Counter - 1,1] = (EntryPrice(1) - (Open[1] + Spread(1)))*(PriceScale/10);							
			End;		
			
		If PipsRiskAndResult[Counter - 1,1] >= 0 then
			Begin
				WinningTrades[Counter - 1] = WinningTrades[Counter - 1] + 1;
				LosingTrades[Counter - 1] = 0;
			End
		Else
			Begin
				LosingTrades[Counter - 1] = LosingTrades[Counter - 1] + 1;
				WinningTrades[Counter - 1] = 0;
			End;
					
		JL1CrossedOverJL2 = False;
		JL1CrossedUnderJL2 = False;
	End;
	
If Dayofweek(Date) = Friday and Time > 1500 then
	Begin
		JL1CrossedOverJL2 = False;
		JL1CrossedUnderJL2 = False;
		ASetupIsActiveS = False;
		ASetupIsActiveL = False;
	End
Else If ((Dayofweek(Date) > Sunday) or (Dayofweek(Date) = Sunday and Time >= 1800) or (Dayofweek(Date) = Friday and Time < 1500)) then
	Begin //Ends at End of Code
			
//Conditions
RedBar = Close of Data3 < Open of Data3;
GreenBar = Close of Data3 > Open of Data3;

CloseLessThanJL2 = Close of Data3 < _JL2;
CloseHigherThanJL2 = Close of Data3 > _JL2;

If CrossOver(_JL1,_JL2,Maxbarsback) then
	Begin	
		JL1CrossedUnderJL2 = False;
		JL1CrossedOverJL2 = True;
	End	
Else If CrossUnder(_JL1,_JL2,Maxbarsback) then
	Begin	
		JL1CrossedOverJL2 = False;
		JL1CrossedUnderJL2 = True;
	End;

//Close Cancels Cross
If CloseCancelsCross = 1 then
	Begin
		If ASetupIsActiveS and Not ASetupIsActiveL and CloseHigherThanJL2 then
			ASetupIsActiveS = False;
		If ASetupIsActiveL and Not ASetupIsActiveS and CloseLessThanJL2 then
			ASetupIsActiveL = False;	
	End;

If UseJLCDFilter = 1 then
	Begin
		MyJLCD = JLCD(JL1, JL2);
		JLCDAvg = (Highest(MyJLCD, JLCDLength) + Lowest(MyJLCD, JLCDLength))/2 ;
		JLCDDiff = MyJLCD - JLCDAvg;
	End;
	
If MP = 0 then
	Begin
		StopIsAtBrkEvnL = False;
		TrailingIsOnL = False;	
		NowTrailingL = False;
		
		StopIsAtBrkEvnS = False;
		TrailingIsOnS = False;	
		NowTrailingS = False;
	End;	
		
//Short ENTRY
If ASetupIsActiveS and Not ASetupIsActiveL then
	Begin
		IF MP = 0 then
			Begin
				//Cancled?
				If JL1CrossedOverJL2 = False then
					Begin
						SellShort ("Short Entry") 10000 Contracts next bar at TheEntryPriceS Stop;
					End	
				Else
					Begin
						ASetupIsActiveS = False;
					End;	
			End;
		IF MP = -1 and MP[1] = 0 then
			//If the setup has entered then... 
			Begin
				PipsRiskAndResult[Counter,0] = PipsRiskS;	
				Counter = Counter + 1;
				ASetupIsActiveS = False;													
			End;		
	End;	

//Long ENTRY
If ASetupIsActiveL and Not ASetupIsActiveS then
	Begin
		IF MP = 0 then
			Begin
				//Cancled?
				If JL1CrossedUnderJL2 = False then
					Begin
						Buy ("Long Entry") 10000 Contracts next bar at TheEntryPriceL Stop;
					End	
				Else
					Begin
						ASetupIsActiveL = False;
					End;	
			End;
		IF MP = 1 and MP[1] = 0 then
			//If the setup has entered then... 
			Begin				
				_Spread = Spread(1);
				PipsRiskAndResult[Counter,0] = PipsRiskL;				
				Counter = Counter + 1;
				ASetupIsActiveL = False;													
			End;		
	End;	

	
	
//Looks for a New Short Position
If JL1CrossedUnderJL2 and RedBar and CloseLessThanJL2 and MP = 0 and ASetupIsActiveL = False and ASetupIsActiveS = False then
	Begin	
	//Reset Settings	
		JL1CrossedUnderJL2 = False;	
		ASetupIsActiveS = True;	
		ASetupIsActiveL = False;
		StopIsAtBrkEvnS = False;
		TrailingIsOnS = False;
		NowTrailingS = False;
		StageOrder = True;
			
	//Set values and Plot the point							
		TheTargetPriceS = Low of Data3 - ((High of Data4 - Low of Data3) * TargetLength);     //Target				
		TheTrailingTgtS = Low of Data3 - ((High of Data4 - Low of Data3) * TrailingTarget);   //Trailing Target
		TheBreakevenTgtS = Low of Data3 - ((High of Data4 - Low of Data3) * BreakevenTarget); //Breakeven Target	
		TheEntryPriceS = Low of Data3 - (EntryOffsetTics/PriceScale);   	 				  //Entry 
		TheStopPriceS = High of Data4  + (StopOffsetTics/PriceScale);     					  //Stop	
						
		If TheBreakevenTgtS > (TheEntryPriceS - Spread(5)) or TheTrailingTgtS > (TheEntryPriceS - Spread(5)) then
			Begin
				StageOrder = False;
				ASetupIsActiveS = False;
			End;
								
		PipsRiskS = ((TheStopPriceS - TheEntryPriceS) + Spread(20) + (20/Pricescale))*(PriceScale/10);
		
		If (UseRiskFilter = 1 and ((PipsRiskS*10) < MinTicsRisk) or ((PipsRiskS*10) > MaxTicsRisk)) or (UseJLCDFilter = 1 and JLCDDiff > 0) then
			Begin
				ASetupIsActiveS = False;
				StageOrder = False;
			End;
			
		If StageOrder = True then
			Begin
				SellShort ("Short Entry ") 10000 Contracts next bar at TheEntryPriceS Stop;			
				StageOrder = False;				
			End;			
	End;		
		
//Looks for a New Long Position
If JL1CrossedOverJL2 and CloseHigherThanJL2 and GreenBar and MP = 0 and ASetupIsActiveL = False and ASetupIsActiveS = False then 
	Begin
	//Reset Settings	
		JL1CrossedOverJL2 = False;		
		ASetupIsActiveL = True;
		ASetupIsActiveS = False;	
		StopIsAtBrkEvnL = False;
		TrailingIsOnL = False;
		NowTrailingL = False;
		StageOrder = True;
			
	//Set values and Plot the point
		TheTargetPriceL = High of Data4 + ((High of Data4 - Low of Data3) * TargetLength);     //Target
		TheTrailingTgtL = High of Data4 + ((High of Data4 - Low of Data3) * TrailingTarget);   //Trailing Target
		TheBreakevenTgtL = High of Data4 + ((High of Data4 - Low of Data3) * BreakevenTarget); //Breakeven Target
		TheEntryPriceL = (High of Data4 + (EntryOffsetTics/PriceScale));   					   //Entry 
		TheStopPriceL = Low of Data3 - (StopOffsetTics/PriceScale);     	   				   //Stop							
		
		If TheBreakevenTgtL < (TheEntryPriceL + Spread(5)) or TheTrailingTgtL < (TheEntryPriceL + Spread(5)) then
			Begin
				StageOrder = False;
				ASetupIsActiveL = False;
			End;
			
		PipsRiskL = ((TheEntryPriceL - TheStopPriceL) + Spread(20) + (20/Pricescale))*(PriceScale/10);				
		
		If (UseRiskFilter = 1 and ((PipsRiskL*10) < MinTicsRisk) or ((PipsRiskL*10) > MaxTicsRisk)) or (UseJLCDFilter = 1 and JLCDDiff < 0) then
			Begin
				ASetupIsActiveL = False;
				StageOrder = False;	
			End;	
			
		If StageOrder = True then
			Begin
				Buy ("Long Entry ") 10000 Contracts next bar at TheEntryPriceL Stop;		
				StageOrder = False;
			End;						
	End;	
	
//Long Breakeven and Trailing Stop	
If MP = 1 then		
	Begin	
		ASetupIsActiveL = False;
	//Breakeven
		//Evaluate if Breakeven Target has been hit
		If HasYetToHitBrkEvnL = False and StopIsAtBrkEvnL = False then
			Begin				
				TheStopPriceL = (TheEntryPriceL + Spread(20)+(10/Pricescale));																	
				StopIsAtBrkEvnL = True;	
			End;		
		
		If StopIsAtBrkEvnL and NowTrailingL = False then
			TheStopPriceL = (TheEntryPriceL + Spread(5)+(10/Pricescale));	
			
	//Trailing	
		//Evaluate if Trailing Target has been hit				
		If HasYetToHitTrialingL = False then
			TrailingIsOnL = True;	
						
		If (TheTrailingPriceL > (TheEntryPriceL + Spread(20))) and TrailingIsOnL = True then
			NowTrailingL = True;	
		
		If NowTrailingL and TheTrailingPriceL < TheTrailingPriceL[1] then
			TheTrailingPriceL = TheTrailingPriceL[1];
					
		If NowTrailingL and TheTrailingPriceL > TheEntryPriceL and TheTrailingPriceL > TheStopPriceL then
			Begin 
				If Close > TheTrailingPriceL then
					TheStopPriceL = TheTrailingPriceL
				Else
					TheStopPriceL = TheStopPriceL[1];	
			End;											
	End;

//Short Breakeven and Trailing Stop
If MP = -1 then		
	Begin	
		ASetupIsActiveS = False;
	//Breakeven
		//Evaluate if Breakeven Target has been hit
		If HasYetToHitBrkEvnS = False and StopIsAtBrkEvnS = False then
			Begin				
				TheStopPriceS = (TheEntryPriceS - Spread(20)-(10/Pricescale));														
				StopIsAtBrkEvnS = True;	
			End;		
		
		If StopIsAtBrkEvnS and NowTrailingS = False then
			TheStopPriceS = (TheEntryPriceS - Spread(5)-(10/Pricescale));
			
	//Trailing	
		//Evaluate if Trailing Target has been hit				
		If HasYetToHitTrialingS = False then
			TrailingIsOnS = True;
						
		If (TheTrailingPriceS < (TheEntryPriceS - Spread(20))) and TrailingIsOnS = True then
			NowTrailingS = True;		
		
		If NowTrailingS and TheTrailingPriceS > TheTrailingPriceS[1] then
			TheTrailingPriceS = TheTrailingPriceS[1];		
							
		If NowTrailingS = True and TheTrailingPriceS < TheEntryPriceS and TheTrailingPriceS < TheStopPriceS then
			Begin
				If Close < TheTrailingPriceS then	
					TheStopPriceS = TheTrailingPriceS
				Else
					TheStopPriceS = TheStopPriceS[1];	
			End;					
	End;
	
//Place Stop if the Trade Has entered
//Short
If TheStopPriceS = TheTrailingPriceS then
	Begin
		BuyToCover ("Short Trailing Stop") 10000 Contracts Next bar at TheStopPriceS Stop;								
	End
Else
	Begin		
		If TheStopPriceS <= TheEntryPriceS then
			BuyToCover ("Short BrkEvn Stop") 10000 Contracts Next bar at TheStopPriceS Stop	
		Else
			BuyToCover ("Short StopLoss") 10000 Contracts Next bar at TheStopPriceS Stop;
	End;
//Long
If TheStopPriceL = TheTrailingPriceL then
	Begin
		Sell ("Long Trailing Stop") 10000 Contracts Next bar at TheStopPriceL Stop;								
	End
Else
	Begin		
		If TheStopPriceL >= TheEntryPriceL then
			Sell ("Long BrkEvn Stop") 10000 Contracts Next bar at TheStopPriceL Stop	
		Else
			Sell ("Long StopLoss") 10000 Contracts Next bar at TheStopPriceL Stop;
	End;	
						

//TARGET
Sell ("Long Target") 10000 Contracts next bar at TheTargetPriceL Limit; 	
BuyToCover ("Short Target") 10000 Contracts next bar at TheTargetPriceS Limit; 

End; // End of Code

If (MP <> 0) and DayofWeek(Date) = Friday and Time > 1459 then
	Begin
		BuyToCover("Weekend Short Exit") 10000 Contracts Next Bar Open;
		Sell("Weekend Long Exit") 10000 Contracts Next Bar Open;
		WeekendExit = True;	
	End;
	
If Getappinfo(Aioptimizing) = 1 and LastBarOnChart then
	Begin
		For Value1 = 0 to 6000			
			Begin
				If PipsRiskAndResult[Value1,0] = 0 Or PipsRiskAndResult[Value1,1] = 0 then
					Begin	
						Value2 = Value1;
						Value3 = Value1;
						If Value1 = 0 then
							Value3 = 1;
						Value1 = 6001;
					End;
			End;			
		AccountSize = StartingAccountSize;		
		EndingAccuracyRate = (Array_Sum(WinningTrades,0,Value2)/(Value3));
		
		If EndingAccuracyRate < 0.30 then MaxNumLosesInARow = 39
		Else If EndingAccuracyRate >= .30 and EndingAccuracyRate < .30625 then MaxNumLosesInARow = 38
		Else If EndingAccuracyRate >= .30625 and EndingAccuracyRate < .31875 then MaxNumLosesInARow = 37 
		Else If EndingAccuracyRate >= .31875 and EndingAccuracyRate < .33125 then MaxNumLosesInARow = 36
		Else If EndingAccuracyRate >= .33125 and EndingAccuracyRate < .34375 then MaxNumLosesInARow = 35 
		Else If EndingAccuracyRate >= .34375 and EndingAccuracyRate < .35277777 then MaxNumLosesInARow = 34
		Else If EndingAccuracyRate >= .35277777 and EndingAccuracyRate < .35833333 then MaxNumLosesInARow = 33 
		Else If EndingAccuracyRate >= .35833333 and EndingAccuracyRate < .36388888 then MaxNumLosesInARow = 32
		Else If EndingAccuracyRate >= .36388888 and EndingAccuracyRate < .36944444 then MaxNumLosesInARow = 31 
		Else If EndingAccuracyRate >= .36944444 and EndingAccuracyRate < .375 then MaxNumLosesInARow = 30
		Else If EndingAccuracyRate >= .375 and EndingAccuracyRate < .38055555 then MaxNumLosesInARow = 29
		Else If EndingAccuracyRate >= .38055555 and EndingAccuracyRate < .38611111 then MaxNumLosesInARow = 28
		Else If EndingAccuracyRate >= .38611111 and EndingAccuracyRate < .39166666 then MaxNumLosesInARow = 27 
		Else If EndingAccuracyRate >= .39166666 and EndingAccuracyRate < .39722222 then MaxNumLosesInARow = 26
		Else If EndingAccuracyRate >= .39722222 and EndingAccuracyRate < .40833333 then MaxNumLosesInARow = 25 
		Else If EndingAccuracyRate >= .40833333 and EndingAccuracyRate < .425 then MaxNumLosesInARow = 24
		Else If EndingAccuracyRate >= .425 and EndingAccuracyRate < .44166666 then MaxNumLosesInARow = 23 
		Else If EndingAccuracyRate >= .44166666 and EndingAccuracyRate < .45833333 then MaxNumLosesInARow = 22
		Else If EndingAccuracyRate >= .45833333 and EndingAccuracyRate < .474833333 then MaxNumLosesInARow = 21 
		Else If EndingAccuracyRate >= .474833333 and EndingAccuracyRate < .4915 then MaxNumLosesInARow = 20
		Else If EndingAccuracyRate >= .4915 and EndingAccuracyRate < .50833333 then MaxNumLosesInARow = 19
		Else If EndingAccuracyRate >= .50833333 and EndingAccuracyRate < .525 then MaxNumLosesInARow = 18
		Else If EndingAccuracyRate >= .525 and EndingAccuracyRate < .54166666 then MaxNumLosesInARow = 17
		Else If EndingAccuracyRate >= .54166666 and EndingAccuracyRate < .5625 then MaxNumLosesInARow = 16
		Else If EndingAccuracyRate >= .5625 and EndingAccuracyRate < .5875 then MaxNumLosesInARow = 15 
		Else If EndingAccuracyRate >= .5875 and EndingAccuracyRate < .625 then MaxNumLosesInARow = 14
		Else If EndingAccuracyRate >= .625 and EndingAccuracyRate < .65833333 then MaxNumLosesInARow = 13
		Else If EndingAccuracyRate >= .65833333 and EndingAccuracyRate < .675 then MaxNumLosesInARow = 12
		Else If EndingAccuracyRate >= .675 and EndingAccuracyRate < .69166666 then MaxNumLosesInARow = 11 
		Else If EndingAccuracyRate >= .69166666 and EndingAccuracyRate < .725 then MaxNumLosesInARow = 10
		Else If EndingAccuracyRate >= .725 and EndingAccuracyRate < .7625 then MaxNumLosesInARow = 9 
		Else If EndingAccuracyRate >= .7625 and EndingAccuracyRate < .7875 then MaxNumLosesInARow = 8					
		Else If EndingAccuracyRate >= .7875 then MaxNumLosesInARow = 7;	
		
		RiskPcentPerTrade = (PercentDrawdown/200)/MaxNumLosesInARow;
		For Value1 = 0 to 6000
			Begin
				If PipsRiskAndResult[Value1,0] = 0 Or PipsRiskAndResult[Value1,1] = 0 then
					Begin	
						Value1 = 6001;
					End	
				Else	
					Begin	
						If Value1 = 6000 then	
							Begin	
								Print("********Not Enough Room In PipsRiskAndResult Array. ERROR!!!*********");	
							End
						Else
							Begin
								$Risk = RiskPcentPerTrade*AccountSize;
								TradeResult = ($Risk/PipsRiskAndResult[Value1,0])*PipsRiskAndResult[Value1,1];
								AccountSize = AccountSize + TradeResult;								
							End;
					End;											
			End;
		
		FileAppend("C:\Users\veee's\Desktop\TestingFile.csv",NumToStr(AccountSize,2)+NewLine);											
	End;
	
	
//Clearprintlog;