{This Section is used to tell the user what to set MaxBarsBack to 
by displaying a number in the print log that should be rounded 
up to nearest hundred which is what MaxBarsBack should be set to.} 
Input:
	JL1(4),
	JL2(9);
	
 Vars:
 	Counting(false),
 	MaxBarsJLsEqual(0),
 	_JL1(0),
 	_JL2(0),
 	_Counter(0),
 	NumBarsJLsEqual(0);
 	
Array: 	
 _NumBarsJLsEqual[](0);

_JL1 = JL(JL1);
_JL2 = JL(JL2);

Array_setmaxindex(_NumBarsJLsEqual,10000);
    
If (_JL1[1] <> _JL2[1]) and (_JL1 = _JL2)then
    Counting = True
Else If (_JL1[1] = _JL2[1]) and (_JL1 <> _JL2) then
    Counting = False;    
    
If Counting then
    Begin
        NumBarsJLsEqual = NumBarsJLsEqual + 1;
    End
Else
    Begin        
        If Counting[1] = True and Counting = False then
            Begin                
                _NumBarsJLsEqual[_Counter] = NumBarsJLsEqual; 
                _Counter = _Counter + 1;    
                NumBarsJLsEqual = 0;
            End;
    End;    

MaxBarsJLsEqual = HighestArray(_NumBarsJLsEqual, _Counter);  

Plot1(MaxBarsJLsEqual, "MaxBarsBack");