/*******************************************************************************
	Use HTTP (via LibHTTP) to send the data to a backend. The backend can be
    created with the PHP scripts provided with this library.                    <br />

	Copyright 2004 Michiel "El Muerte" Hendriks                                 <br />
	Released under the Lesser Open Unreal Mod License                           <br />
	http://wiki.beyondunreal.com/wiki/LesserOpenUnrealModLicense

	<!-- $Id: TraqCommHTTP.uc,v 1.1 2004/12/20 14:19:18 elmuerte Exp $ -->
*******************************************************************************/

class TraqCommHTTP extends TraqCommNetwork;

/** HttpSock class to use. By default uses the standard LibHTTP HttpSock */
var() class<HttpSock> HttpSockClass;
/** instance of the HttpSock class used */
var protected HttpSock HttpSock;

event Created()
{
    HttpSock = spawn(HttpSockClass);
}

function CleanUp()
{
    if (HttpSock != none)
    {
        HttpSock.Destroy();
        HttpSock = none;
    }
}

/**
	requests a TraqID from the server. This is required in order for a succesful
	tracking session.
*/
function RequestTraqID()
{
	local TraqDataSimple tds;
	tds = new class'TraqDataSimple';
	tds.setString("MapName", Left(string(Level), InStr(string(Level), ".")));
	tds.setString("GameType", GetItemName(string(Level.Game.Class)));
	tds.setInteger("ServerPort", Level.Game.GetServerPort());

	HttpSock.clearFormData();
	HttpSock.setFormData("GameInfo", tds.Serialize());
	HttpSock.OnComplete = ReceivedTraqID;
	HttpSock.post("http://el-muerte.student.utwente.nl/test/TraqID.php");
}

/** will be called when a TraqID request was completed */
function ReceivedTraqID(HttpSock Sender)
{
	local string key,value;
	Sender.OnComplete = none;
	if (Sender.ReturnData.Length > 0)
	{
		if (class'TraqDataObject'.static.UnserializeString(key, value, Sender.ReturnData[0]) && (key ~= "TraqID"))
		{
			TraqID = Value;
			log("Game received TraqID:"@TraqID, name);
		}
	}
}

function SyncData()
{
	local int i;
	if (TraqID == "")
	{
		log("Won't sync data: no TraqID", name);
		return;
	}
	if (HttpSock.curState != HTTPState_Closed)
	{
		log("Won't sync data: socket not done with previous request", name);
		return;
	}
	HttpSock.clearFormData();
	HttpSock.setFormData("TraqID", TraqID);
	for (i = 0; i < TraqData.length; i++)
	{
		HttpSock.setFormData("TraqData["$string(TraqData[i].Name)$"]", TraqData[i].Serialize());
	}
	HttpSock.post("http://el-muerte.student.utwente.nl/test/LibGameTraq.php");
}

defaultproperties
{
    HttpSockClass=class'HttpSock'
}
