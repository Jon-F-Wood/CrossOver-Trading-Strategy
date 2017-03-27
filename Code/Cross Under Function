Input:
	Number1(Numeric),
	Number2(Numeric),
	BarsBack(Numeric);

//Reset CrossUnder after 1 Bar
CrossUnder = False;

//Obvious CrossUnder
If (Number1[1] > Number2[1]) and (Number1 < Number2) then
	CrossUnder = True; 	

//Not So obvious CrossUnder
If (Number1[1] = Number2[1]) and (Number1 < Number2) then 
	Begin
		For Value1 = 1 to BarsBack //Loop through until...
			Begin
				If Number1[Value1] <> Number2[Value1] then //...it is found where the numbers are no longer equil
					Begin									
						If Number1[Value1] > Number2[Value1] then //check if it was below before
							Begin
								CrossUnder = True;
							End
						Else
							Begin
								CrossUnder = False;
							End;
									
						Value1 = BarsBack + 1;		
					End;
				
				//Assume that if that if the last evaluated bar is reached and is still equal then there is a CrossUnder
				If Value1 = BarsBack and (Number1[Value1] = Number2[Value1]) then 
					Begin
						CrossUnder = True;
					End;	
			End;
	End;	

