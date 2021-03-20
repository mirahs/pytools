export default class Packet {
	public packetId: number = 0;

	private _byte: Laya.Byte;


	constructor(buffer?: ArrayBuffer) {
		this._byte = new Laya.Byte(buffer);
		this._byte.pos = 0;
		this._byte.endian = Laya.Byte.BIG_ENDIAN; //设置为大端；
	}


	public Encode(packetId: number): void {
		this.packetId = packetId;
		var all: Laya.Byte = new Laya.Byte(4 + this._byte.length);
		all.endian = Laya.Byte.BIG_ENDIAN; //设置为大端；
		all.writeUint16(this._byte.length + 2);
		all.writeUint16(packetId);
		all.writeArrayBuffer(this._byte.buffer);
		this._byte = all;
	}

	public Buffer(): ArrayBuffer {
		return this._byte.buffer
	}

	public GetBuffer(): Laya.Byte {
		return this._byte;
	}

	public WriteBuffer(v: Laya.Byte): void {
		this._byte.writeArrayBuffer(v.buffer, 0);
	}

	public Reset(): void {
		this._byte.pos = 0;
	}


	public WriteByte(v: number): void {
		this._byte.writeByte(v);
	}

	public WriteSbyte(v: number): void {
		this._byte.writeUint8(v);
	}

	public WriteUshort(v: number): void {
		this._byte.writeUint16(v);
	}

	public WriteShort(v: number): void {
		this._byte.writeInt16(v);
	}

	public WriteUint(v: number): void {
		this._byte.writeUint32(v);
	}

	public WriteInt(v: number): void {
		this._byte.writeInt32(v);
	}

	public WriteUlong(v: number): void {
		const zeros: string = "00000000";
		var str: string = v.toString(16);
		str = zeros.substr(0, 16 - str.length) + str;
		this.WriteUint(parseInt(str.substr(0, 8), 16));
		this.WriteUint(parseInt(str.substr(8, 8), 16));
	}

	public WriteLong(v: number): void {
		const zeros: string = "00000000";
		var str: string = v.toString(16);
		str = zeros.substr(0, 16 - str.length) + str;
		this.WriteInt(parseInt(str.substr(0, 8), 16));
		this.WriteInt(parseInt(str.substr(8, 8), 16));
	}

	public WriteFloat(v: number): void {
		this._byte.writeFloat32(v);
	}

	public WriteDouble(v: number): void {
		this._byte.writeFloat64(v);
	}

	public WriteString(v: string): void {
		this._byte.writeUTFString(v);
	}


	public ReadByte(): number {
		return this._byte.getUint8();
	}

	public ReadSbyte(): number {
		return this._byte.getByte();
	}

	public ReadUshort(): number {
		return this._byte.getUint16();
	}

	public ReadShort(): number {
		return this._byte.getInt16();
	}

	public ReadUint(): number {
		return this._byte.getUint32();
	}

	public ReadInt(): number {
		return this._byte.getInt32();
	}

	public ReadUlong(): number {
		const zeros: string = "00000000";
		var s: string = this.ReadUint().toString(16);
		var str: string = zeros.substr(0, 8 - s.length) + s;
		s = this.ReadUint().toString(16);
		str += zeros.substr(0, 8 - s.length) + s;
		return Number(parseInt(str, 16).toString());
	}

	public ReadLong(): number {
		const zeros: string = "00000000";
		var s: string = this.ReadInt().toString(16);
		var str: string = zeros.substr(0, 8 - s.length) + s;
		s = this.ReadInt().toString(16);
		str += zeros.substr(0, 8 - s.length) + s;
		return Number(parseInt(str, 16).toString());
	}

	public ReadFloat(): number {
		return this._byte.getFloat32();
	}

	public ReadDouble(): number {
		return this._byte.getFloat64();
	}

	public ReadString(): string {
		return this._byte.getUTFString();
	}
}
