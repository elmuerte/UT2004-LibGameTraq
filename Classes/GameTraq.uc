/*******************************************************************************
	Main class of LibGameTraq. You should subclass this to add extra
	functionality and set the default values.                                   <br />

	Copyright 2004 Michiel "El Muerte" Hendriks                                 <br />
	Released under the Lesser Open Unreal Mod License                           <br />
	http://wiki.beyondunreal.com/wiki/LesserOpenUnrealModLicense

	<!-- $Id: GameTraq.uc,v 1.1 2004/12/20 14:19:18 elmuerte Exp $ -->
*******************************************************************************/
/*

	client                  server
	general data
					->
							register info
							reply traqid + magicnumber
					<-
	decode traqid
	with magicnumber?

	traqid + data   ->      ?
*/
class GameTraq extends Info;

/** socket class to use */
var() class<TraqComm> TraqCommClass;
/** handle to our socket */
var protected TraqComm TraqComm;

/** contains the information that will be send to the remote server */
var protected array<TraqDataObject> TraqData;

/** initial setup of the game */
event PreBeginPlay()
{
    super.PreBeginPlay();
	TraqComm = new(self) TraqCommClass;
	if (TraqComm == none)
    {
        Error("Could not spawn TraqComm instance:"@TraqCommClass);
        return;
    }
	NewSession();
}

/** Actor is about to be destroyed. Make sure everything is cleaned up */
event Destroyed()
{
    CleanUpTraqData();
    if (TraqComm != none) TraqComm.Cleanup();
    super.Destroyed();
}

/** will clean up the TraqData objects */
protected function CleanUpTraqData()
{
    local int i;
    for (i = 0; i < TraqData.Length; i++)
    {
        TraqData[i].Cleanup();
        TraqData[i] = none;
    }
    TraqData.Length = 0;
}

/** accessor function for the TraqID */
function string getTraqID()
{
    if (TraqComm == none) return "";
	return TraqComm.TraqID;
}

/** Creates a new session. This will clean up all data objects and request a new
    TraqID */
function NewSession()
{
    CleanUpTraqData();
    TraqComm.Initialize();
}

/**
	Create a new data object. The NewName value must be unique. If succesful a
	reference to the created data object will be returned.
*/
function TraqDataObject CreateDataObject(name NewName, optional class<TraqDataObject> NewClass)
{
	local TraqDataObject obj;
	local int i;
	for (i = 0; i < TraqData.Length; i++)
	{
		if (TraqData[i].name == NewName) return none;
	}
	if (NewClass == none) NewClass = class'TraqDataObject';
	obj = new(self,string(NewName)) NewClass;
	TraqData.Length = i+1;
	if (obj == none) return none;
	TraqData[i] = obj;
	return obj;
}

/**
	Sync the data with the tracking server. Returns when succesfull
*/
function bool SyncData()
{
    if (TraqComm == none) return false;
    if (!TraqComm.IsReady()) return false;
    TraqComm.SyncData();
}

defaultproperties
{
	TraqCommClass=class'TraqCommLog'
}
