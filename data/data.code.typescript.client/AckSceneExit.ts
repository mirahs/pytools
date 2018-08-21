namespace proto {
export class AckSceneExit
{
	private _uid: number;


	constructor(packet: net.Packet) {
		this._uid = packet.ReadUint();
	}


	public get uid(): number { return this._uid; }
	public set uid(value: number) { this._uid = value; }
}
}