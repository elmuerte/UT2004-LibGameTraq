/*******************************************************************************
	A TraqComm client that simply stored the data in a log file in the UserLogs
    directory. This is mainly implemented for testing purposes, but could also
    be used in conjunction with a client side application.                      <br />

	Copyright 2004 Michiel "El Muerte" Hendriks                                 <br />
	Released under the Lesser Open Unreal Mod License                           <br />
	http://wiki.beyondunreal.com/wiki/LesserOpenUnrealModLicense

	<!-- $Id: TraqCommLog.uc,v 1.1 2004/12/20 14:19:18 elmuerte Exp $ -->
*******************************************************************************/

class TraqCommLog extends TraqComm;

var protected FileLog Flog;

event Created()
{
    Flog = spawn(class'FileLog');
}

function Initialize()
{
    TraqID = GenerateTraqID();
}

function CleanUp()
{
    if (Flog != none)
    {
        Flog.Destroy();
        Flog = none;
    }
}
