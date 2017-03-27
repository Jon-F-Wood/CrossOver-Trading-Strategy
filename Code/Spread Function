Input:
	BarsBack(Numeric);
	
Vars:
	_Spread(0),
	AvgSpread(0);
	
_Spread = ((H data2 - H)+(O data2 - O)+(L data2 - L)+(C data2 - C))/4;
AvgSpread = Average(_Spread,BarsBack);

Spread = AvgSpread;	