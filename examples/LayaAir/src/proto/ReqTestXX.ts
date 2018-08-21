namespace proto {
export class ReqTestXX
{
	private _id_u8: number;
	private _id_u16: number;
	private _id_u32: number;
	private _repeat_id_u8: number[] = [];
	private optional_id_u8_flag: number = 0;
	private _optional_id_u8: number;


	public Encode(): net.Packet {
		let packet: net.Packet = new net.Packet();
		packet.WriteByte(this._id_u8);
		packet.WriteUshort(this._id_u16);
		packet.WriteUint(this._id_u32);
		let repeat_id_u8_count: number = this._repeat_id_u8.length;
		packet.WriteUshort(repeat_id_u8_count);
		for (var i: number = 0; i < repeat_id_u8_count; i++)
		{
			let xxx: number = this._repeat_id_u8[i];
			packet.WriteByte(xxx);
		}
		packet.WriteByte(this.optional_id_u8_flag);
		if (this.optional_id_u8_flag == 1)
		{
			packet.WriteByte(this._optional_id_u8);
		}
		packet.Encode(40040);
		return packet;
	}


	public get id_u8(): number { return this._id_u8; }
	public set id_u8(value: number) { this._id_u8 = value; }
	public get id_u16(): number { return this._id_u16; }
	public set id_u16(value: number) { this._id_u16 = value; }
	public get id_u32(): number { return this._id_u32; }
	public set id_u32(value: number) { this._id_u32 = value; }
	public get repeat_id_u8(): number[] {return this._repeat_id_u8; }
	public set repeat_id_u8(value: number[]) { this._repeat_id_u8 = value; }
	public get optional_id_u8(): number { return this._optional_id_u8; }
	public set optional_id_u8(value: number) { this.optional_id_u8_flag = 1; this._optional_id_u8 = value; }
}
}