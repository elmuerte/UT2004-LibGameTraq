/*******************************************************************************
	Data object that holds information. This is the base class, you can create
	more specific data containers by subclassing. Make sure you also add support
	for these new data containers to the backend script (PHP).                  <br />

	Copyright 2004 Michiel "El Muerte" Hendriks                                 <br />
	Released under the Lesser Open Unreal Mod License                           <br />
	http://wiki.beyondunreal.com/wiki/LesserOpenUnrealModLicense

	<!-- $Id: TraqDataObject.uc,v 1.1 2004/12/20 14:19:18 elmuerte Exp $ -->
*******************************************************************************/

class TraqDataObject extends Object /*abstract*/;

/** record types */
var const int RT_UNKNOWN, RT_STRING, RT_INTEGER, RT_FLOAT, RT_BOOL, RT_OBJECT;

/**
    Will be called when this object has to be destroyed for a new session. Or
    when the parent is destroyed. <br />
    Use this function to clean up the object, e.g. remove all references to
    Objects\Actors, if you do not do this weird things will happen.
*/
function CleanUp();

/**
	Returns a serialized version of the data storage. This returns a string that
	will be send to the backend server. Read the SERIALIZATION.TXT document for
	the serialization information
*/
final function string Serialize()
{
	return GetItemName(string(Class))$"{"$SerializeSelf()$"};";
}

/**
	override this function to generate the serialized information stored in this
	storage container
*/
protected function string SerializeSelf()
{
	return "";
}

/** returns the first record type */
function static int firstRecordType(string data)
{
	local string t;
	t = Left(data, InStr(data, ":"));
	switch (t)
	{
		case "s":   return default.RT_STRING;
		case "i":   return default.RT_INTEGER;
		case "f":   return default.RT_FLOAT;
		case "b":   return default.RT_BOOL;
		case "o":   return default.RT_OBJECT;
	}
	return default.RT_UNKNOWN;
}

/** serialize a string */
final static function string serializeString(string Key, string Value)
{
	return "s:"$Key$":\""$repl(repl(Value, "\\", "\\\\"), "\"", "\\\"")$"\";";
}

/**
	unserialize a string; returns true when succesfull. The unserialized string
	will be removed from the data value. If false is returned the rest of the
	data might be corrupted.
*/
final static function bool unserializeString(out string Key, out string Value, out string data)
{
	local int i;
	if (left(Data, 2) != "s:") return false; // check if "s:"
	data = mid(data, 2);
	i = InStr(data, ":");
	key = mid(data, 0, i); // get Key
	data = mid(data, i+1);
	if (mid(data, 0, 1) != "\"") return false;
	i = 1;
	while (i < Len(data)-1 && mid(data, i, 1) != "\"")
	{
		i++;
		if (mid(data, i, 1) != "\\") i++;
	}
	if (mid(data, i, 1) != "\"") return false; // unterminated string
	if (mid(data, i+1, 1) != ";") return false; // unterminated property
	Value = mid(data, 1, i-1);
	Value = repl(repl(Value, "\\\"", "\""), "\\\\", "\\");
	data = mid(data, i+2);
	return true;
}

final static function string serializeInteger(string Key, int Value)
{
	return "i:"$Key$":"$string(value)$";";
}

final static function string serializeFloat(string Key, float Value)
{
	return "f:"$Key$":"$string(value)$";";
}

final static function string serializeBool(string Key, bool Value)
{
	return "b:"$Key$":"$string(value)$";";
}

final static function string serializeObject(string Key, TraqDataObject Value)
{
	return "o:"$Key$":"$Value.Serialize();
}

defaultproperties
{
	RT_UNKNOWN=-1
	RT_STRING=1
	RT_INTEGER=2
	RT_FLOAT=3
	RT_BOOL=4
	RT_OBJECT=5
}
