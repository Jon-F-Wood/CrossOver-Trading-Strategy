Inputs:
	UseJLCDFilter(0), 
	JLCDLength(7),

Vars:
	MyJLCD(0),
	JLCDAvg(0),
	JLCDDiff(0),


If UseJLCDFilter = 1 then
	Begin
		MyJLCD = JLCD(JL1, JL2);
		JLCDAvg = (Highest(MyJLCD, JLCDLength) + Lowest(MyJLCD, JLCDLength))/2 ;
		JLCDDiff = MyJLCD - JLCDAvg;
	End;

//Short Position 
	
		If (UseRiskFilter = 1 and ((PipsRiskS*10) < MinTicsRisk) or ((PipsRiskS*10) > MaxTicsRisk)) or (UseJLCDFilter = 1 and JLCDDiff > 0) then
			Begin
				ASetupIsActiveS = False;
				StageOrder = False;
			End;
//Long Position

		If (UseRiskFilter = 1 and ((PipsRiskL*10) < MinTicsRisk) or ((PipsRiskL*10) > MaxTicsRisk)) or (UseJLCDFilter = 1 and JLCDDiff < 0) then
			Begin
				ASetupIsActiveL = False;
				StageOrder = False;	
			End;