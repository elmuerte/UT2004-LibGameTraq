/*******************************************************************************
	LibGameTraq communication handler. This is the base class for the actual
    storing of the serialized data. Subclass this to add support for a new
    storage method.                                                             <br />

	Copyright 2004 Michiel "El Muerte" Hendriks                                 <br />
	Released under the Lesser Open Unreal Mod License                           <br />
	http://wiki.beyondunreal.com/wiki/LesserOpenUnrealModLicense

	<!-- $Id: TraqComm.uc,v 1.1 2004/12/20 14:19:18 elmuerte Exp $ -->
*******************************************************************************/

class TraqComm extends Object within GameTraq abstract;

/** will contain the ID for the current game\session */
var string TraqID;

/** object created, spawn required classes here */
event Created();

/**
    Will be called when the parent will be destroyed. <br />
    Use this function to clean up the object, e.g. remove all references to
    Objects\Actors, if you do not do this weird things will happen.
*/
function CleanUp();

/** Initialize the comm object for a new session. */
function Initialize()
{
    TraqID = "";
}

/** is the communication class ready to save the data */
function bool IsReady()
{
    return (TraqID != "");
}

/** store the dataobjects */
function SyncData()
{
}

/** creates a valid TraqID */
static function string GenerateTraqID()
{
    return class'HttpSock'.static.randString(16, "TID_");
}
