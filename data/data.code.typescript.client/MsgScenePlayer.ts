namespace proto {
export class MsgScenePlayer
{
	private _uid: number;
	private _scene_rot_pos: MsgSceneRotPos;


	public Encode(): game.util.Packet {
		let packet: game.util.Packet = new game.util.Packet();
		packet.WriteUint(this._uid);
		packet.WriteBuffer(this._scene_rot_pos.GetBuffer());
		return packet;
	}


	constructor(packet: game.util.Packet) {
		this._uid = packet.ReadUint();
		this._scene_rot_pos = new MsgSceneRotPos(packet);
	}

	public GetBuffer(): ByteBuffer
	{
		return this.Encode().GetBuffer();
	}


	public get uid(): number { return this._uid; }
	public set uid(value: number) { this._uid = value; }
	public get scene_rot_pos(): MsgSceneRotPos { return this._scene_rot_pos; }
	public set scene_rot_pos(value: MsgSceneRotPos) { this._scene_rot_pos = value; }
}
}
