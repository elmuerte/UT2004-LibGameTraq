class TEST_post extends info;

var GameTraq q;

event PreBeginPlay()
{
	q = spawn(class'GameTraq');
	q.CreateDataObject('HighScore');
	q.CreateDataObject('BladeeBla');
	SetTimer(10, false);
}

event Timer()
{
	q.SyncData();
}
