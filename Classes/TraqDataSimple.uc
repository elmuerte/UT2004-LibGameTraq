/*******************************************************************************
	A simply traqdata object, contains an array with variables.                 <br />

	Copyright 2004 Michiel "El Muerte" Hendriks                                 <br />
	Released under the Lesser Open Unreal Mod License                           <br />
	http://wiki.beyondunreal.com/wiki/LesserOpenUnrealModLicense

	<!-- $Id: TraqDataSimple.uc,v 1.1 2004/12/20 14:19:18 elmuerte Exp $ -->
*******************************************************************************/

class TraqDataSimple extends TraqDataObject;

/** failed to add an entry */
const SR_FAILED     = 0;
/** entry simply added */
const SR_ADD        = 1; // 00000001
/** new value set for the entry */
const SR_SET        = 2; // 00000010
/** new value set and type converted */
const SR_SET_TYPE   = 6; // 00000110

/** supported data type */
enum EDataType
{
    DT_String,
    DT_Integer,
    DT_Float,
    DT_Bool,
};

/** data entry */
struct TDEntry
{
    /** must be an identifier */
    var string name; // maybe convert to "name" type?
    /** the string value */
    var string value;
    var EDataType type;
};

/** data entries */
var protected array<TDEntry> entries;

function byte setString(string key, coerce string value)
{
    return set(key, value, DT_String);
}

function byte setInteger(string key, coerce int value)
{
    return set(key, value, DT_Integer);
}

function byte setFloat(string key, coerce float value)
{
    return set(key, value, DT_Float);
}

function byte setBool(string key, coerce bool value)
{
    return set(key, value, DT_Bool);
}

/**
    set or add a new entry. returns a byte correcsponding to the actions taken. <br />
    <ul>
        <li><code>SR_FAILED</code> (0) - failed to add an entry</li>
        <li><code>SR_ADD</code> (1) - entry simply added</li>
        <li><code>SR_SET</code> (2) - entry set</li>
        <li><code>SR_SET_TYPE</code> (6) - entry set and type updated, use
            <code>set() & 2 != 0</code> to test if an entry was set</li>
    </ul>
*/
function byte set(string key, coerce string value, EDataType type)
{
    local int i;
    local byte retval;
    retval = SR_ADD;
    for (i = 0; i < entries.length; i++)
    {
        if (entries[i].name ~= key)
        {
            if (entries[i].type != type) retval = SR_SET_TYPE;
            else retval = SR_SET;
            break;
        }
    }
    if (entries.length <= i) entries.length = i+1;
    entries[i].name = key;
    entries[i].value = value;
    entries[i].type = type;
    return retval;
}

/** remove a value */
function bool remove(string key)
{
    local int i;
    for (i = 0; i < entries.length; i++)
    {
        if (entries[i].name ~= key)
        {
            entries.Remove(i, 1);
            return true;
        }
    }
    return false;
}

protected function string SerializeSelf()
{
    local int i;
    local string retval;
    for (i = 0; i < entries.Length; i++)
    {
        switch (entries[i].type)
        {
            case DT_String:     retval $= serializeString(entries[i].name, entries[i].value); break;
            case DT_Integer:    retval $= serializeInteger(entries[i].name, int(entries[i].value)); break;
            case DT_Float:      retval $= serializeFloat(entries[i].name, float(entries[i].value)); break;
            case DT_Bool:       retval $= serializeBool(entries[i].name, bool(entries[i].value)); break;
        }
    }
    return retval;
}
