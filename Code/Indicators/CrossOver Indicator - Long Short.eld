//Data1 = Shorter Timeframe Bid
//Data2 = Shorter Timeframe Ask
//Data3 = Longer Timeframe Bid
//Data4 = Longer Timeframe Ask

Inputs:  	
	_____LONG_TRADES_____(1),	   //1 = Plot Long Trades.  0 = Don't Plot Long Trades.
	L.10_TargetLength(3.031), 	   //High + ((High - Low) * Tgt) = The Price that the Target is Placed
	L.20_TrailingJL(16),		   //JL used for Trailing
	L.21_TrailingTarget(1),        //The Point at which the trade begins to trail
	L.22_TrailingOffSetTics(0),    //How Many ticks Below the MA the Stop is Trailed	
	L.30_BreakevenTarget(1.77),    //High + ((High - Low) * BreakevenTarget) = The Price Where the StopLoss is moved up to Breakeven
	L.31_BreakEvenTics(10),	       //Number of tics The Breakeven is offset for Slippage
	L.40_EntryOffsetTics(20),      //High + (EntryOffsetTics/PriceScale) = the Price where the Entry is Placed
	L.50_StopOffsetTics(10),       //Low - (StopOffsetTIcs/PriceScale) = The Price where the StopLoss is Placed	
	L.60_JL1(7),		   	 	   //Length of JumpLine 1 (Typically is JL1 < JL2)
	L.61_JL2(6), 			       //Length of JumpLine 2 (Typically is JL2 > JL1)
	_____SHORT_TRADES_____(1),	   //1 = Plot Short Trades.  0 = Don't Plot Short Trades.
	S.10_TargetLength(3.031), 	   //High + ((High - Low) * Tgt) = The Price that the Target is Placed
	S.20_TrailingJL(16),		   //JL used for Trailing
	S.21_TrailingTarget(1),        //The Point at which the trade begins to trail
	S.22_TrailingOffSetTics(0),    //How Many ticks Below the MA the Stop is Trailed	
	S.30_BreakevenTarget(1.77),    //High + ((High - Low) * BreakevenTarget) = The Price Where the StopLoss is moved up to Breakeven
	S.31_BreakEvenTics(10),	       //Number of tics The Breakeven is offset for Slippage
	S.40_EntryOffsetTics(20),      //High + (EntryOffsetTics/PriceScale) = the Price where the Entry is Placed
	S.50_StopOffsetTics(10),       //Low - (StopOffsetTIcs/PriceScale) = The Price where the StopLoss is Placed	
	S.60_JL1(7),		   	 	   //Length of JumpLine 1 (Typically is JL1 < JL2)
	S.61_JL2(6), 			       //Length of JumpLine 2 (Typically is JL2 > JL1)
	PlotAddons(0);                 //Plot all Setups even when in the Market.  1/On : 0/Off
		
Variables:
	L.JL1(0), 				   //JumpLine1 (Tenkan-Sen)
	L.JL2(0), 				   //JumpLine2	(Tenkan-Sen)
	L.TrailingJL(0),		   //JumpLine used for trailing
	
	S.JL1(0), 				   //JumpLine1 (Tenkan-Sen)
	S.JL2(0), 				   //JumpLine2	(Tenkan-Sen)
	S.TrailingJL(0),			   //JumpLine used for trailing
	
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

	BlankPlot(0),			   //Used to make a Blank Plot
	
//Conditional Variables that Hold thier value until changed by a condition	
	LookForNewSetupS(True),      //MA1 is Greater than MA2
	LookForNewSetupL(True),      //MA1 is Lesser than MA2
	
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
	
	L.JL1IsMoreThanL.JL2(False),   //JL is Higher Than JL2
	L.JL1IsLessThanL.JL2(False),	 //JL1 is Less Than JL2
	
	S.JL1IsMoreThanS.JL2(False),   //JL is Higher Than JL2
	S.JL1IsLessThanS.JL2(False),	 //JL1 is Less Than JL2
	
	L.CloseLessThanL.JL2(False),   //The Close price of the Current Bar is Lower Than the JL2 Value
	L.CloseMoreThanL.JL2(False), //The Close price of the Current Bar is Higher Than the JL2 Value
	
	S.CloseLessThanS.JL2(False),   //The Close price of the Current Bar is Lower Than the JL2 Value
	S.CloseMoreThanS.JL2(False), //The Close price of the Current Bar is Higher Than the JL2 Value
	
	HasNotEnteredYetS(False),    //The Low of the Current Bar Is Higher Than the Currently Active Short Position's Entry Price (It hasn't Entered Yet)
	HasNotEnteredYetL(False),    //The High of the Current Bar Is Less Than the Currently Active Long Position's Entry Price (It hasn't Entered Yet)	
	
	HasYetToHitStopS(False),     //The High of the Current Bar is Lower than the Currently Active Short Position's Stop Price (It hasn't Stopped Out Yet)
	HasYetToHitStopL(False),     //The Low of the Current Bar is Higher than the Currently Active Long Position's Stop Price (It hasn't Stopped Out Yet)
	
	HasYetToHitBrkEvnS(False),	 //The Low Of the Current Bar is Higher than the Currently Acive Short Position's Breakeven Target (BrkEvn Tgt has yet to be Hit)
	HasYetToHitBrkEvnL(False),	 //The High Of the Current Bar is Lower than the Currently Acive Long Position's Breakeven Target (BrkEvn Tgt has yet to be Hit)
	
	HasYetToHitTrialingS(False), //The Low Of the Current Bar is Higher than the Currently Acive Short Position's Trailing Target (Trailing Tgt has yet to be Hit)
	HasYetToHitTrialingL(False), //The High Of the Current Bar is Lower than the Currently Acive Long Position's Trailing Target (Trailing Tgt has yet to be Hit)
	
	HasYetToHitTargetS(False),   //The Low Of the Current Bar is Higher than the Currently Acive Short Position's Target Price (It hasn't Hit Target Yet)
	HasYetToHitTargetL(False),   //The High Of the Current Bar is Lower than the Currently Acive Long Position's Target Price (It hasn't Hit Target Yet) 
 	
 	NotForPreviousBarS(False),	 //The Setup Conditions of CloseIsLessThanMA2, MA1IsLessThanMA2 and RedBar are Not true For the Prevous Bar
 	NotForPreviousBarL(False),	 //The Setup Conditions of CloseIsHigherThanMA2 and MA1IsHigherThanMA2 and GreenBar are Not true For the Prevous Bar
 	
 	CurrentlyInMarketS(False), //Used to tell whether or not the system is currently in a Short position or not
 	CurrentlyInMarketL(False), //Used to tell whether or not the system is currently in a Long position or not
 	asdf(0),

//Change PlotAddons from True/False input to On/Off input (1/On : 0/Off) 
	_PlotAddons(True);      //Last Declaration of a Variable  

If PlotAddons = 1 then
	_PlotAddons = True
Else
	_PlotAddons = False;	

asdf = Getbdcashbalance(GetAccountID);
Plot99(asdf);


//Moving Averages	
L.JL1 =  (Highest(High of Data3, L.60_JL1) + Lowest(Low of Data3, L.60_JL1))/2 ;
L.JL2 = (Highest(High of Data3, L.61_JL2) + Lowest(Low of Data3, L.61_JL2))/2  ;
L.TrailingJL = (Highest(High of Data3, L.20_TrailingJL) + Lowest(Low of Data3, L.20_TrailingJL))/2  ;

S.JL1 =  (Highest(High of Data3, S.60_JL1) + Lowest(Low of Data3, S.60_JL1))/2 ;
S.JL2 = (Highest(High of Data3, S.61_JL2) + Lowest(Low of Data3, S.61_JL2))/2  ;
S.TrailingJL = (Highest(High of Data3, S.20_TrailingJL) + Lowest(Low of Data3, S.20_TrailingJL))/2  ;

If _____LONG_TRADES_____ = 1 and _____SHORT_TRADES_____ = 0 then 
	Begin
		Plot1(L.JL1,"JL1");
		Plot2(L.JL2, "JL2");
		Plot3(L.TrailingJL, "TrailingJL"); 
	End;	
If _____LONG_TRADES_____ = 0 and _____SHORT_TRADES_____ = 1 then 
	Begin
		Plot1(S.JL1,"JL1");
		Plot2(S.JL2, "JL2");
		Plot3(S.TrailingJL, "TrailingJL"); 
	End;	

//Set the Trailing Price
TheTrailingPriceS = S.TrailingJL + (S.22_TrailingOffSetTics/PriceScale);
TheTrailingPriceL = L.TrailingJL - (L.22_TrailingOffSetTics/PriceScale);

//Conditions
RedBar = Close of Data3 < Open of Data3;
GreenBar = Close of Data3 > Open of Data3;

L.CloseLessThanL.JL2 = Close of Data3 < L.JL2;
L.CloseMoreThanL.JL2 = Close of Data3 > L.JL2;
S.CloseLessThanS.JL2 = Close of Data3 < S.JL2;
S.CloseMoreThanS.JL2 = Close of Data3 > S.JL2;

L.JL1IsMoreThanL.JL2 = L.JL1 > L.JL2;
L.JL1IsLessThanL.JL2 = L.JL1 < L.JL2;
S.JL1IsMoreThanS.JL2 = S.JL1 > S.JL2;
S.JL1IsLessThanS.JL2 = S.JL1 < S.JL2;

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

NotForPreviousBarS = not S.CloseLessThanS.JL2[1] or not S.JL1IsLessThanS.JL2[1] or not RedBar[1];
NotForPreviousBarL = not L.CloseMoreThanL.JL2[1] or not L.JL1IsMoreThanL.JL2[1] or not GreenBar[1];	

SetPlotColor(1, Rgb(255,128,128));
SetPlotColor(2, Green);
SetPlotColor(3, Blue);
SetPlotColor(4, Black);
SetPlotColor(5, DarkGray);
SetPlotColor(6, DarkGray);
SetPlotColor(7, DarkGray);
SetPlotColor(8, DarkGray);
SetPlotColor(9, DarkGray);
SetPlotColor(10, Black);
SetPlotColor(11, DarkGray);
SetPlotColor(12, DarkGray);
SetPlotColor(13, Black);
SetPlotColor(14, DarkGray);
SetPlotColor(15, DarkGray);
SetPlotColor(16, Black);
SetPlotColor(17, DarkGray);
SetPlotColor(18, DarkGray);
SetPlotColor(19, DarkGray);
SetPlotColor(20, DarkGray);
SetPlotColor(21, DarkGray);
SetPlotColor(50, Black);

SetPlotWidth(1, 0);
SetPlotWidth(2, 0);
SetPlotWidth(3, 0);
SetPlotWidth(4, 0);
SetPlotWidth(5, 3);
SetPlotWidth(6, 0);
SetPlotWidth(7, 2);
SetPlotWidth(8, 0);
SetPlotWidth(9, 2);
SetPlotWidth(10, 0);
SetPlotWidth(11, 0);
SetPlotWidth(12, 2);
SetPlotWidth(13, 0);
SetPlotWidth(14, 0);
SetPlotWidth(15, 0);
SetPlotWidth(16, 0);
SetPlotWidth(17, 3);
SetPlotWidth(18, 0);
SetPlotWidth(19, 2);
SetPlotWidth(20, 0);
SetPlotWidth(21, 2);
SetPlotWidth(50, 0);

//Short ENTRY
If ASetupIsActiveS and Not ASetupIsActiveL then
	Begin
		IF HasNotEnteredYetS then
			Begin
				//Cancled?
				If S.JL1IsMoreThanS.JL2 = False then
					Begin
						Plot8(TheEntryPriceS, "Entry", Cyan);
					End	
				Else
					Begin
						ASetupIsActiveS = False;
					End;	
			End
		Else
			//If the setup has entered then... 
			Begin				
				CurrentlyInMarketS = True;
				ASetupIsActiveS = False;													
			End;		
	End;	

//Long ENTRY
If ASetupIsActiveL and Not ASetupIsActiveS then
	Begin
		IF HasNotEnteredYetL then
			Begin
				//Cancled?
				If L.JL1IsLessThanL.JL2 = False then
					Begin
						Plot8(TheEntryPriceL, "Entry", Cyan);
					End	
				Else
					Begin
						ASetupIsActiveL = False;
					End;	
			End
		Else
			//If the setup has entered then... 
			Begin				
				CurrentlyInMarketL = True;
				ASetupIsActiveL = False;													
			End;		
	End;	


//Short STOPLOSS	
If ASetupIsActiveS or CurrentlyInMarketS and ( Not ASetupIsActiveL or Not CurrentlyInMarketL ) then
	Begin	
	//If There is a trade that has entered...	
		If CurrentlyInMarketS and Not CurrentlyInMarketL then		
			Begin		
			//Evaluate if Stop has been Hit	
				If HasYetToHitStopS = False then
					Begin
					//Is the Trade A Breakeven Or Trailing	
						If TheStopPriceS <= TheEntryPriceS then 
							Begin		
							//Gapping?	
								If Open > TheStopPriceS then
									Begin		
										CurrentlyInMarketS = False;											
										
										If TheStopPriceS = TheTrailingPriceS then
											SetPlotColor(12,Rgb(0,0,170))
										Else
											SetPlotColor(12,Yellow);
											
									//Exit at Open		
										Plot12(Open, "Exit");
										StopIsAtBrkEvnS = False;						
										NowTrailingS = False;
									End
								Else
								//No Gapping	
									Begin		
										CurrentlyInMarketS = False;	
										
										If TheStopPriceS = TheTrailingPriceS then
											SetPlotColor(12,Rgb(0,0,170))
										Else
											SetPlotColor(12,Yellow);
											
										Plot12(TheStopPriceS, "Exit");
										StopIsAtBrkEvnS = False;						
										NowTrailingS = False;
									End;
							End
					//Fixed Stop	
						Else
							Begin
							//Gapping?	
								If Open > TheStopPriceS then
									Begin
										CurrentlyInMarketS = False;
										
										If StopIsAtBrkEvnS = False then								
											SetPlotColor(12,Rgb(166,0,0));												
									
									//Exit at Open	
										Plot12(Open, "Exit");
										StopIsAtBrkEvnS = False;						
										NowTrailingS = False;
									End
								Else
								//No Gapping	
									Begin
										CurrentlyInMarketS = False;
										
										If StopIsAtBrkEvnS = False then								
											SetPlotColor(12,Rgb(166,0,0));	
											
										Plot12(TheStopPriceS, "Exit");
										StopIsAtBrkEvnS = False;						
										NowTrailingS = False;
									End;		
							End;	
					End;		
			End;
	//Breakeven and Trailing Stop	
		If CurrentlyInMarketS and Not CurrentlyInMarketL then		
			Begin	
			//Breakeven
				//Evaluate if Breakeven Target has been hit
				If HasYetToHitBrkEvnS = False then
					Begin	
						TheStopPriceS = (TheEntryPriceS - (S.31_BreakEvenTics/PriceScale));
					//Does the bar hit Breakeven Target then get stopped out on the Same Bar?	
						If Close of Data2 >= TheStopPriceS then
							Begin
								CurrentlyInMarketS = False;
								SetPlotColor(12,Yellow);
								Plot12(TheStopPriceS, "Exit");
								StopIsAtBrkEvnS = False;						
								NowTrailingS = False;	
							End
						Else
							Begin							
								StopIsAtBrkEvnS = True;	
							End;
					End;		
					
			//Trailing	
				//Evaluate if Trailing Target has been hit
				If HasYetToHitTrialingS = False then
					Begin
						TrailingIsOnS = True;	
					End;
				
				If TheTrailingPriceS < TheEntryPriceS then
					Begin								
						If TrailingIsOnS  = True then 
							Begin
								NowTrailingS = True;
							End;								
					End;
				
				If NowTrailingS then
					Begin
						If TheTrailingPriceS > TheTrailingPriceS[1] then
							TheTrailingPriceS = TheTrailingPriceS[1];
					End;		
									
				If NowTrailingS = True and TheTrailingPriceS < TheEntryPriceS then
					TheStopPriceS = TheTrailingPriceS;				
			End;
			
	//Plot Stop a long as the Target hasn't been hit yet
		If HasYetToHitTargetS and Not CurrentlyInMarketL then
			Begin
				If ASetupIsActiveS or CurrentlyInMarketS = True then
					Plot9 (TheStopPriceS, "Stop", Cyan);
			End;
	End;

//Long STOPLOSS	
If ASetupIsActiveL or CurrentlyInMarketL and ( Not ASetupIsActiveS or Not CurrentlyInMarketS ) then
	Begin	
	//If There is a trade that has entered...	
		If CurrentlyInMarketL and Not CurrentlyInMarketS then		
			Begin		
			//Evaluate if Stop has been Hit	
				If HasYetToHitStopL = False then
					Begin
					//Is the Trade A Breakeven Or Trailing?	
						If TheStopPriceL >= TheEntryPriceL then 
							Begin
							//Gapping?	
								If Open < TheStopPriceL then
									Begin		
										CurrentlyInMarketL = False;										
										
										If TheStopPriceL = TheTrailingPriceL then
											SetPlotColor(12,Rgb(0,0,170))
										Else
											SetPlotColor(12,Yellow);
											
									//If so Exit at the Open of the next bar		
										Plot12(Open, "Exit");
										StopIsAtBrkEvnL = False;						
										NowTrailingL = False;
									End
								Else
								//No Gapping	
									Begin
										CurrentlyInMarketL = False;										
										
										If TheStopPriceL = TheTrailingPriceL then
											SetPlotColor(12,Rgb(0,0,170))
										Else
											SetPlotColor(12,Yellow);
											
									//If so Exit at the Open of the next bar		
										Plot12(TheStopPriceL, "Exit");
										StopIsAtBrkEvnL = False;						
										NowTrailingL = False;
									End;
							End		
					//Fixed Stop 	
						Else
							Begin
							//Gapping?	
								If Open < TheStopPriceL Then
									Begin								
										CurrentlyInMarketL = False;
										
										If StopIsAtBrkEvnL = False then								
											SetPlotColor(12,Rgb(166,0,0));
											
										Plot12(Open, "Exit");
										StopIsAtBrkEvnL = False;						
										NowTrailingL = False;
									End
								Else
								//No Gapping	
									Begin
										CurrentlyInMarketL = False;
										
										If StopIsAtBrkEvnL = False then								
											SetPlotColor(12,Rgb(166,0,0));
											
										Plot12(TheStopPriceL, "Exit");
										StopIsAtBrkEvnL = False;						
										NowTrailingL = False;
									End;		
							End;	
					End;		
			End;
	//Breakeven and Trailing Stop	
		If CurrentlyInMarketL and Not CurrentlyInMarketS then		
			Begin	
			//Breakeven
				//Evaluate if Breakeven Target has been hit
				If HasYetToHitBrkEvnL = False then
					Begin	
						TheStopPriceL = (TheEntryPriceL + (L.31_BreakEvenTics/PriceScale));
					//Does the bar hit Breakeven Target then get stopped out on the Same Bar?	
						If Close <= TheStopPriceL then
							Begin
								CurrentlyInMarketL = False;
								SetPlotColor(12,Yellow);
								Plot12(TheStopPriceL, "Exit");
								StopIsAtBrkEvnL = False;						
								NowTrailingL = False;	
							End
						Else
							Begin							
								StopIsAtBrkEvnL = True;	
							End;
					End;		
					
			//Trailing	
				//Evaluate if Trailing Target has been hit				
				If HasYetToHitTrialingL = False then
					Begin
						TrailingIsOnL = True;	
					End;
								
				If TheTrailingPriceL > TheEntryPriceL then
					Begin
						If TrailingIsOnL  = True then 
							Begin
								NowTrailingL = True;
							End;								
					End;
				
				If NowTrailingL then
					Begin
						If TheTrailingPriceL < TheTrailingPriceL[1] then
							TheTrailingPriceL = TheTrailingPriceL[1];
					End;		
					
				If NowTrailingL and TheTrailingPriceL > TheEntryPriceL then
					TheStopPriceL = TheTrailingPriceL;				
			End;
			
	//Plot Stop a long as the Target hasn't been hit yet
		If HasYetToHitTargetL and Not CurrentlyInMarketS then
			Begin
				If ASetupIsActiveL or CurrentlyInMarketL = True then
					Plot9(TheStopPriceL, "Stop", Cyan);
			End;
	End;


//Short TARGET
If CurrentlyInMarketS = True and Not CurrentlyInMarketL then
	Begin
		If HasYetToHitTargetS = False then
			Begin
			//Gapping	
				If Open of Data2 < TheTargetPriceS then
					Begin
						CurrentlyInMarketS = False;				
						Plot12(Open of Data2,"Exit", DarkGreen);
						StopIsAtBrkEvnS = False;
						NowTrailingS = False;
					End
				Else
				//No Gapping	
					Begin	
						CurrentlyInMarketS = False;				
						Plot12(TheTargetPriceS,"Exit", DarkGreen);
						StopIsAtBrkEvnS = False;
						NowTrailingS = False;
					End;	
			End;
	End;		

//Long TARGET
If CurrentlyInMarketL = True and Not CurrentlyInMarketS then
	Begin
		If HasYetToHitTargetL = False then
			Begin
			//Gapping	
				If Open > TheTargetPriceL then
					Begin
						CurrentlyInMarketL = False;				
						Plot12(Open,"Exit", DarkGreen);
						StopIsAtBrkEvnL = False;
						NowTrailingL = False;
					End
				Else
				//No Gapping	
					Begin	
						CurrentlyInMarketL = False;				
						Plot12(TheTargetPriceL,"Exit", DarkGreen);
						StopIsAtBrkEvnL = False;
						NowTrailingL = False;
					End;	
			End;
	End;	
	
//Looks for a New Short Position
If _____SHORT_TRADES_____ = 1 then 
	Begin		
		If S.JL1IsMoreThanS.JL2 then LookForNewSetupS = True;
		
		If LookForNewSetupS and CurrentlyInMarketS = False and CurrentlyInMarketL = False then 
			Begin
				If S.CloseLessThanS.JL2 and S.JL1IsLessThanS.JL2 and NotForPreviousBarS and RedBar then //there is a setup
					Begin
					//Stop looking for now
						LookForNewSetupS = False;
					//Make Setup Active	
						ASetupIsActiveS = True;	
						StopIsAtBrkEvnS = False;
						TrailingIsOnS = False;
						NowTrailingS = False;	
					//Set values and Plot the point							
						TheTargetPriceS = Low of Data3 - ((High of Data4 - Low of Data3) * S.10_TargetLength);     //Target				
						TheTrailingTgtS = Low of Data3 - ((High of Data4 - Low of Data3) * S.21_TrailingTarget);   //Trailing Target
						TheBreakevenTgtS = Low of Data3 - ((High of Data4 - Low of Data3) * S.30_BreakevenTarget); //Breakeven Target	
						TheEntryPriceS = Low of Data3 - (S.40_EntryOffsetTics/PriceScale);   	  		  //Entry 
						TheStopPriceS = High of Data4  + (S.50_StopOffsetTics/PriceScale);     	   				  //Stop	
										
						If TheBreakevenTgtS > TheEntryPriceS then
							TheBreakevenTgtS = TheEntryPriceS;
							
						If TheTrailingTgtS > TheEntryPriceS then
							TheTrailingTgtS = TheEntryPriceS;
												
						Plot5(TheTargetPriceS, "Target", Cyan);
						Plot6(TheTrailingTgtS, "TrailTgt", Cyan);				
						Plot7(TheBreakevenTgtS, "BrkEvnTgt", Cyan);
						Plot8(TheEntryPriceS, "Entry", Cyan);
						Plot9(TheStopPriceS, "Stop", Cyan);	
						Plot14((TheStopPriceS - TheEntryPriceS)*(PriceScale/10),"Pips Risk ", Cyan);
						Plot15((TheEntryPriceS - TheTargetPriceS)/(TheStopPriceS - TheEntryPriceS),"R:R ", Cyan);			
					End;	
			End;
	End;
//Looks for a New Long Position
If _____LONG_TRADES_____ = 1 then
	Begin		
		If L.JL1IsLessThanL.JL2 then LookForNewSetupL = True;
		
		If LookForNewSetupL and CurrentlyInMarketL = False and CurrentlyInMarketS = False then 
			Begin
				If L.CloseMoreThanL.JL2 and L.JL1IsMoreThanL.JL2 and NotForPreviousBarL and GreenBar then //there is a setup
					Begin
					//Stop looking for now
						LookForNewSetupL = False;
					//Make Setup Active	
						ASetupIsActiveL = True;	
						StopIsAtBrkEvnL = False;
						TrailingIsOnL = False;
						NowTrailingL = False;	
					//Set values and Plot the point
						TheTargetPriceL = High of Data4 + ((High of Data4 - Low of Data3) * L.10_TargetLength);     //Target
						TheTrailingTgtL = High of Data4 + ((High of Data4 - Low of Data3) * L.21_TrailingTarget);   //Trailing Target
						TheBreakevenTgtL = High of Data4 + ((High of Data4 - Low of Data3) * L.30_BreakevenTarget); //Breakeven Target
						TheEntryPriceL = High of Data4 + (L.40_EntryOffsetTics/PriceScale);   			   //Entry 
						TheStopPriceL = Low of Data3 - (L.50_StopOffsetTics/PriceScale);     	   				   //Stop				
														
						If TheBreakevenTgtL < TheEntryPriceL then
							TheBreakevenTgtL = TheEntryPriceL;
							
						If TheTrailingTgtL < TheEntryPriceL then
							TheTrailingTgtL = TheEntryPriceL;
						
						Plot5(TheTargetPriceL, "Target", Cyan);
						Plot6(TheTrailingTgtL, "TrailTgt", Cyan);	
						Plot7(TheBreakevenTgtL, "BrkEvnTgt", Cyan);					
						Plot8(TheEntryPriceL, "Entry", Cyan);
						Plot9(TheStopPriceL, "Stop", Cyan);	
						Plot14((TheEntryPriceL - TheStopPriceL)*(PriceScale/10), "Pips Risk ", Cyan);
						Plot15((TheTargetPriceL - TheEntryPriceL)/(TheEntryPriceL - TheStopPriceL), "R:R ", Cyan);				
					End;	
			End;
	End;

//Addon Trades	
If _____SHORT_TRADES_____ = 1 then
	Begin		
		If LookForNewSetupS then 
			Begin
				If S.CloseLessThanS.JL2 and S.JL1IsLessThanS.JL2 and NotForPreviousBarS and RedBar then 
					Begin
					//Stop looking for now
						LookForNewSetupS = False;
					//Plot the point 
						Value1 = Low of Data3 - ((High of Data4 - Low of Data3) * S.10_TargetLength); 				
						Value2 = Low of Data3 - ((High of Data4 - Low of Data3) * S.21_TrailingTarget);							
						Value3 = Low of Data3 - ((High of Data4 - Low of Data3) * S.30_BreakevenTarget);
						Value4 = Low of Data3 - (S.40_EntryOffsetTics/PriceScale);  
						Value5 = High of Data4 + (S.50_StopOffsetTics/PriceScale); 	
						
							
						If Value4 > Value1 then
							Value4 = Value1;
							
						If Value5 > Value1 then
							Value5 = Value1;
																
						If _PlotAddons then
							Begin	
								Plot17(Value1, "*Tgt");						
								Plot18(Value2, "*TrailTgt");
								Plot19(Value3, "*BrkEvnTgt");
								Plot20(Value4, "*Entry");
								Plot21(Value5, "*Stop");						
							End;	
					End;		
			End;			
	End;

//Addon Trades	
If _____LONG_TRADES_____ = 1 then
	Begin		
		If LookForNewSetupL then 
			Begin
				If L.CloseMoreThanL.JL2 and L.JL1IsMoreThanL.JL2 and NotForPreviousBarL and GreenBar then 
					Begin
					//Stop looking for now
						LookForNewSetupL = False;
					//Plot the point 
						Value6 = High of Data4 + ((High of Data4 - Low of Data3) * L.10_TargetLength); 				
						Value7 = High of Data4 + ((High of Data4 - Low of Data3) * L.21_TrailingTarget);
						Value8 = High of Data4 + ((High of Data4 - Low of Data3) * L.30_BreakevenTarget);
						Value9 = High of Data4 + (L.40_EntryOffsetTics/PriceScale);  
						Value10 = Low of Data3 - (L.50_StopOffsetTics/PriceScale); 
										
							
						If Value9 < Value6 then
							Value9 = Value6;
							
						If Value10 < Value6 then
							Value10 = Value6;
																
						If _PlotAddons then
							Begin	
								Plot17(Value6, "*Tgt");
								Plot18(Value7, "*TrailTgt");						
								Plot19(Value8, "*BrkEvnTgt");
								Plot20(Value9, "*Entry");
								Plot21(Value10, "*Stop");						
							End;	
					End;		
			End;			
	End;

//Misc	
If High = 99999999999 then 
	Begin	
		Plot4(BlankPlot,"=========");
		Plot10(BlankPlot,"=========");
		Plot13(BlankPlot,"=========");
		Plot16(BlankPlot,"=========");
		Plot50(BlankPlot,"=========");	
		
	End;
		
If ASetupIsActiveL[1] or CurrentlyInMarketL[1] then
	Begin	
		SetPlotColor[1](11, Green);
		Plot11[1]("Long", "Type");
	End;
	
If ASetupIsActiveS[1] or CurrentlyInMarketS[1] then
	Begin	
		SetPlotColor[1](11, Red);
		Plot11[1]("Short", "Type");				
	End;					