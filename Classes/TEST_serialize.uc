class TEST_serialize extends Commandlet;

event int Main( string Parms )
{
    local TraqDataObject tdq;

    tdq = new class'TraqDataObject';
    log(tdq.Serialize());
    log(tdq.SerializeString("string1", "this is a string"));
    log(tdq.SerializeString("string2", "a string with a \" and a \\"));
    log(tdq.SerializeInteger("integer1", 123));
    log(tdq.SerializeInteger("integer2", -123));
    log(tdq.SerializeFloat("float1", 1.2345678));
    log(tdq.SerializeFloat("float2", -1.2345678));
    log(tdq.SerializeBool("bool1", true));
    log(tdq.SerializeBool("bool2", false));

    return 0;
}

defaultproperties
{
    ShowBanner=false
}
