using System.Collections;
using System.Collections.Generic;


public class AckTestJsOk
{
	private ulong _u64;
	private long _i64;


	public Packet Encode()
	{
		Packet packet = new Packet();
		packet.WriteUlong(this._u64);
		packet.WriteLong(this._i64);
		packet.Encode(Msg.P_ACK_TEST_JS_OK);
		return packet;
	}


	public ulong u64
	{
		get { return this._u64; }
		set { this._u64 = value; }
	}

	public long i64
	{
		get { return this._i64; }
		set { this._i64 = value; }
	}

}
