import Packet from '../net/Packet'


export default class ReqTestJs
{
	private _u64: number;
	private _i64: number;


	public Encode(): Packet {
		let packet: Packet = new Packet();
		packet.WriteUlong(this._u64);
		packet.WriteLong(this._i64);
		packet.Encode(40080);
		return packet;
	}


	public get u64(): number { return this._u64; }
	public set u64(value: number) { this._u64 = value; }
	public get i64(): number { return this._i64; }
	public set i64(value: number) { this._i64 = value; }
}
