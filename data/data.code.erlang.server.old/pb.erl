-module(pb).

-include("common.hrl").

-compile(export_all).


%% 发送聊天信息
req_chat_send(Bin0) ->
	{Channel, Bin1} = ?D(u8, Bin0),
	{DestUid, Bin2} = ?D(u32, Bin1),
	{Content, Bin3} = ?D(string, Bin2),
	#req_chat_send{channel=Channel,dest_uid=DestUid,content=Content}.

%% 聊天信息返回
ack_chat_send_ok(#ack_chat_send_ok{channel=Channel,uid=Uid,uname=Uname,content=Content}) ->
	Bin1 = ?E(u8, Channel),
	Bin2 = ?E(u32, Uid),
	Bin3 = ?E(string, Uname),
	Bin4 = ?E(string, Content),
	BinData = <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary>>,
	?MSG(1520, BinData).

%% GM命令
req_chat_gm(Bin0) ->
	{Content, Bin1} = ?D(string, Bin0),
	#req_chat_gm{content=Content}.

%% 角色登录
req_role_login(Bin0) ->
	{Uid, Bin1} = ?D(u32, Bin0),
	{Uuid, Bin2} = ?D(u32, Bin1),
	{Sid, Bin3} = ?D(u16, Bin2),
	{Cid, Bin4} = ?D(u16, Bin3),
	{LoginTime, Bin5} = ?D(u32, Bin4),
	{Pwd, Bin6} = ?D(string, Bin5),
	{Relink, Bin7} = ?D(u8, Bin6),
	{Debug, Bin8} = ?D(u8, Bin7),
	{Os, Bin9} = ?D(string, Bin8),
	{Version, Bin10} = ?D(string, Bin9),
	#req_role_login{uid=Uid,uuid=Uuid,sid=Sid,cid=Cid,login_time=LoginTime,pwd=Pwd,relink=Relink,debug=Debug,os=Os,version=Version}.

%% 角色创建
req_role_create(Bin0) ->
	{Uid, Bin1} = ?D(u32, Bin0),
	{Uuid, Bin2} = ?D(u32, Bin1),
	{Sid, Bin3} = ?D(u16, Bin2),
	{Cid, Bin4} = ?D(u16, Bin3),
	{Os, Bin5} = ?D(string, Bin4),
	{Version, Bin6} = ?D(string, Bin5),
	{Uname, Bin7} = ?D(string, Bin6),
	{Source, Bin8} = ?D(string, Bin7),
	{SourceSub, Bin9} = ?D(string, Bin8),
	{LoginTime, Bin10} = ?D(u32, Bin9),
	#req_role_create{uid=Uid,uuid=Uuid,sid=Sid,cid=Cid,os=Os,version=Version,uname=Uname,source=Source,source_sub=SourceSub,login_time=LoginTime}.

%% 请求随机名字
req_role_rand_name(Bin0) ->
	#req_role_rand_name{}.

%% 随机名字返回
ack_role_rand_name_ok(#ack_role_rand_name_ok{uname=Uname}) ->
	Bin1 = ?E(string, Uname),
	BinData = <<Bin1/binary>>,
	?MSG(1040, BinData).

%% 登录成功
ack_role_login_ok(#ack_role_login_ok{uname=Uname}) ->
	Bin1 = ?E(string, Uname),
	BinData = <<Bin1/binary>>,
	?MSG(1050, BinData).

%% 登录成功(无角色)
ack_role_login_ok_no_role(#ack_role_login_ok_no_role{}) ->
	BinData = <<>>,
	?MSG(1060, BinData).

%% 请求进入场景(飞)
req_scene_enter_fly(Bin0) ->
	{MapId, Bin1} = ?D(u32, Bin0),
	#req_scene_enter_fly{map_id=MapId}.

%% 请求进入场景
req_scene_enter(Bin0) ->
	{DoorId, Bin1} = ?D(u32, Bin0),
	#req_scene_enter{door_id=DoorId}.

%% 行走数据
req_scene_move(Bin0) ->
	{SceneRotPos, Bin1} = msg_scene_rot_pos_decode(Bin0),
	{Forward, Bin2} = msg_scene_vector_3_decode(Bin1),
	{AniName, Bin3} = ?D(string, Bin2),
	{XAxis, Bin4} = ?D(i16, Bin3),
	#req_scene_move{scene_rot_pos=SceneRotPos,forward=Forward,ani_name=AniName,x_axis=XAxis}.

%% 进入场景成功
ack_scene_enter(#ack_scene_enter{player=Player}) ->
	Bin1 = msg_scene_player_encode(Player),
	BinData = <<Bin1/binary>>,
	?MSG(2040, BinData).

%% 场景玩家列表
ack_scene_players(#ack_scene_players{players=Players}) ->
	FunPlayers = fun(FPlayers, {CountAcc, BinAcc}) ->
			FBin = msg_scene_player_encode(FPlayers),
			{CountAcc + 1, <<BinAcc/binary,FBin/binary>>}
	end,
	{CountPlayers, BinPlayers} = lists:foldl(FunPlayers, {0, <<>>}, Players),
	Bin1 = ?E(u16, CountPlayers),
	Bin2 = BinPlayers,
	BinData = <<Bin1/binary,Bin2/binary>>,
	?MSG(2050, BinData).

%% 退出场景成功
ack_scene_exit(#ack_scene_exit{uid=Uid}) ->
	Bin1 = ?E(u32, Uid),
	BinData = <<Bin1/binary>>,
	?MSG(2060, BinData).

%% 请求玩家列表
req_scene_req_players(Bin0) ->
	#req_scene_req_players{}.

%% 行走数据
ack_scene_move(#ack_scene_move{scene_rot_pos=SceneRotPos,forward=Forward,ani_name=AniName,x_axis=XAxis,uid=Uid}) ->
	Bin1 = msg_scene_rot_pos_encode(SceneRotPos),
	Bin2 = msg_scene_vector_3_encode(Forward),
	Bin3 = ?E(string, AniName),
	Bin4 = ?E(i16, XAxis),
	Bin5 = ?E(u32, Uid),
	BinData = <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary,Bin5/binary>>,
	?MSG(2080, BinData).

%% 玩家基础信息
msg_role_base_encode(#msg_role_base{uid=Uid,uname=Uname}) ->
	Bin1 = ?E(u32, Uid),
	Bin2 = ?E(string, Uname),
	<<Bin1/binary,Bin2/binary>>.
msg_role_base_decode(Bin0) ->
	{Uid, Bin1} = ?D(u32, Bin0),
	{Uname, Bin2} = ?D(string, Bin1),
	{#msg_role_base{uid=Uid,uname=Uname}, Bin2}.

%% 添加好友基础信息
msg_friend_base_add_encode(#msg_friend_base_add{uid=Uid,uname=Uname}) ->
	Bin1 = ?E(u32, Uid),
	Bin2 = ?E(string, Uname),
	<<Bin1/binary,Bin2/binary>>.
msg_friend_base_add_decode(Bin0) ->
	{Uid, Bin1} = ?D(u32, Bin0),
	{Uname, Bin2} = ?D(string, Bin1),
	{#msg_friend_base_add{uid=Uid,uname=Uname}, Bin2}.

%% 场景玩家旋转和位置信息
msg_scene_rot_pos_encode(#msg_scene_rot_pos{rot_x=RotX,rot_y=RotY,rot_z=RotZ,pos_x=PosX,pos_y=PosY,pos_z=PosZ}) ->
	Bin1 = ?E(i16, RotX),
	Bin2 = ?E(i16, RotY),
	Bin3 = ?E(i16, RotZ),
	Bin4 = ?E(i16, PosX),
	Bin5 = ?E(i16, PosY),
	Bin6 = ?E(i16, PosZ),
	<<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary,Bin5/binary,Bin6/binary>>.
msg_scene_rot_pos_decode(Bin0) ->
	{RotX, Bin1} = ?D(i16, Bin0),
	{RotY, Bin2} = ?D(i16, Bin1),
	{RotZ, Bin3} = ?D(i16, Bin2),
	{PosX, Bin4} = ?D(i16, Bin3),
	{PosY, Bin5} = ?D(i16, Bin4),
	{PosZ, Bin6} = ?D(i16, Bin5),
	{#msg_scene_rot_pos{rot_x=RotX,rot_y=RotY,rot_z=RotZ,pos_x=PosX,pos_y=PosY,pos_z=PosZ}, Bin6}.

%% 场景玩家旋转和位置信息
msg_scene_player_encode(#msg_scene_player{uid=Uid,scene_rot_pos=SceneRotPos}) ->
	Bin1 = ?E(u32, Uid),
	Bin2 = msg_scene_rot_pos_encode(SceneRotPos),
	<<Bin1/binary,Bin2/binary>>.
msg_scene_player_decode(Bin0) ->
	{Uid, Bin1} = ?D(u32, Bin0),
	{SceneRotPos, Bin2} = msg_scene_rot_pos_decode(Bin1),
	{#msg_scene_player{uid=Uid,scene_rot_pos=SceneRotPos}, Bin2}.

%% 场景Vector3信息
msg_scene_vector_3_encode(#msg_scene_vector_3{x=X,y=Y,z=Z}) ->
	Bin1 = ?E(i16, X),
	Bin2 = ?E(i16, Y),
	Bin3 = ?E(i16, Z),
	<<Bin1/binary,Bin2/binary,Bin3/binary>>.
msg_scene_vector_3_decode(Bin0) ->
	{X, Bin1} = ?D(i16, Bin0),
	{Y, Bin2} = ?D(i16, Bin1),
	{Z, Bin3} = ?D(i16, Bin2),
	{#msg_scene_vector_3{x=X,y=Y,z=Z}, Bin3}.

%% 
msg_test_x_x_encode(#msg_test_x_x{id_u8=IdU8,id_f32=IdF32,id_op_u8=IdOpU8}) ->
	Bin1 = ?E(u8, IdU8),
	FunIdF32 = fun(FIdF32, {CountAcc, BinAcc}) ->
			FBin = ?E(f32, FIdF32),
			{CountAcc + 1, <<BinAcc/binary,FBin/binary>>}
	end,
	{CountIdF32, BinIdF32} = lists:foldl(FunIdF32, {0, <<>>}, IdF32),
	Bin2 = ?E(u16, CountIdF32),
	Bin3 = BinIdF32,
	Bin4 = 
		case IdOpU8 of
			undefined ->
				?E(u8, 0);
			_ ->
				BinIdOpU8Flag = ?E(u8, 1),
				BinIdOpU8= ?E(u8, IdOpU8),
				<<BinIdOpU8Flag/binary,BinIdOpU8/binary>>
		end,
	<<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary>>.
msg_test_x_x_decode(Bin0) ->
	{IdU8, Bin1} = ?D(u8, Bin0),
	{IdF32Count, Bin2} = ?D(u16, Bin1),
	FunIdF32 = fun(_, {IdF32Acc, BinIdF32Acc}) ->
				{FunIdF32, BinIdF32Acc2} = ?D(f32, BinIdF32Acc),
				{[FunIdF32|IdF32Acc], BinIdF32Acc2}
			end,
	{IdF32, Bin3} = lists:foldl(FunIdF32, {[], Bin2}, lists:duplicate(IdF32Count, 0)),
	{IdOpU8Flag, Bin4} = ?D(u8, Bin3),
	{IdOpU8, Bin5} =
	case IdOpU8Flag of
		0 ->
			{undefined, Bin4};
		1 ->
			?D(u8, Bin4)
	end,
	{#msg_test_x_x{id_u8=IdU8,id_f32=IdF32,id_op_u8=IdOpU8}, Bin5}.

%% 测试发送
req_test_send(Bin0) ->
	{IdU8, Bin1} = ?D(u8, Bin0),
	{RoleBase, Bin2} = msg_role_base_decode(Bin1),
	{IdF32Count, Bin3} = ?D(u16, Bin2),
	FunIdF32 = fun(_, {IdF32Acc, BinIdF32Acc}) ->
				{FunIdF32, BinIdF32Acc2} = ?D(f32, BinIdF32Acc),
				{[FunIdF32|IdF32Acc], BinIdF32Acc2}
			end,
	{IdF32, Bin4} = lists:foldl(FunIdF32, {[], Bin3}, lists:duplicate(IdF32Count, 0)),
	{IdOpU8Flag, Bin5} = ?D(u8, Bin4),
	{IdOpU8, Bin6} =
	case IdOpU8Flag of
		0 ->
			{undefined, Bin5};
		1 ->
			?D(u8, Bin5)
	end,
	{OpRoleBaseFlag, Bin7} = ?D(u8, Bin6),
	{OpRoleBase, Bin8} =
	case OpRoleBaseFlag of
		0 ->
			{undefined, Bin7};
		1 ->
			msg_role_base_decode(Bin7)
	end,
	#req_test_send{id_u8=IdU8,role_base=RoleBase,id_f32=IdF32,id_op_u8=IdOpU8,op_role_base=OpRoleBase}.

%% 测试返回
ack_test_send_ok(#ack_test_send_ok{id_u8=IdU8,role_base=RoleBase,id_f32=IdF32,id_op_u8=IdOpU8,op_role_base=OpRoleBase}) ->
	Bin1 = ?E(u8, IdU8),
	Bin2 = msg_role_base_encode(RoleBase),
	FunIdF32 = fun(FIdF32, {CountAcc, BinAcc}) ->
			FBin = ?E(f32, FIdF32),
			{CountAcc + 1, <<BinAcc/binary,FBin/binary>>}
	end,
	{CountIdF32, BinIdF32} = lists:foldl(FunIdF32, {0, <<>>}, IdF32),
	Bin3 = ?E(u16, CountIdF32),
	Bin4 = BinIdF32,
	Bin5 = 
		case IdOpU8 of
			undefined ->
				?E(u8, 0);
			_ ->
				BinIdOpU8Flag = ?E(u8, 1),
				BinIdOpU8= ?E(u8, IdOpU8),
				<<BinIdOpU8Flag/binary,BinIdOpU8/binary>>
		end,
	Bin6 = 
		case OpRoleBase of
			undefined ->
				?E(u8, 0);
			_ ->
				BinOpRoleBaseFlag = ?E(u8, 1),
				BinOpRoleBase = msg_role_base_encode(OpRoleBase),
				<<BinOpRoleBaseFlag/binary,BinOpRoleBase/binary>>
		end,
	BinData = <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary,Bin5/binary,Bin6/binary>>,
	?MSG(40020, BinData).

%% 测试信息块
msg_test_send_encode(#msg_test_send{id_u8=IdU8,role_base=RoleBase,id_f32=IdF32,id_op_u8=IdOpU8,op_role_base=OpRoleBase}) ->
	Bin1 = ?E(u8, IdU8),
	Bin2 = msg_role_base_encode(RoleBase),
	FunIdF32 = fun(FIdF32, {CountAcc, BinAcc}) ->
			FBin = ?E(f32, FIdF32),
			{CountAcc + 1, <<BinAcc/binary,FBin/binary>>}
	end,
	{CountIdF32, BinIdF32} = lists:foldl(FunIdF32, {0, <<>>}, IdF32),
	Bin3 = ?E(u16, CountIdF32),
	Bin4 = BinIdF32,
	Bin5 = 
		case IdOpU8 of
			undefined ->
				?E(u8, 0);
			_ ->
				BinIdOpU8Flag = ?E(u8, 1),
				BinIdOpU8= ?E(u8, IdOpU8),
				<<BinIdOpU8Flag/binary,BinIdOpU8/binary>>
		end,
	Bin6 = 
		case OpRoleBase of
			undefined ->
				?E(u8, 0);
			_ ->
				BinOpRoleBaseFlag = ?E(u8, 1),
				BinOpRoleBase = msg_role_base_encode(OpRoleBase),
				<<BinOpRoleBaseFlag/binary,BinOpRoleBase/binary>>
		end,
	<<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary,Bin5/binary,Bin6/binary>>.
msg_test_send_decode(Bin0) ->
	{IdU8, Bin1} = ?D(u8, Bin0),
	{RoleBase, Bin2} = msg_role_base_decode(Bin1),
	{IdF32Count, Bin3} = ?D(u16, Bin2),
	FunIdF32 = fun(_, {IdF32Acc, BinIdF32Acc}) ->
				{FunIdF32, BinIdF32Acc2} = ?D(f32, BinIdF32Acc),
				{[FunIdF32|IdF32Acc], BinIdF32Acc2}
			end,
	{IdF32, Bin4} = lists:foldl(FunIdF32, {[], Bin3}, lists:duplicate(IdF32Count, 0)),
	{IdOpU8Flag, Bin5} = ?D(u8, Bin4),
	{IdOpU8, Bin6} =
	case IdOpU8Flag of
		0 ->
			{undefined, Bin5};
		1 ->
			?D(u8, Bin5)
	end,
	{OpRoleBaseFlag, Bin7} = ?D(u8, Bin6),
	{OpRoleBase, Bin8} =
	case OpRoleBaseFlag of
		0 ->
			{undefined, Bin7};
		1 ->
			msg_role_base_decode(Bin7)
	end,
	{#msg_test_send{id_u8=IdU8,role_base=RoleBase,id_f32=IdF32,id_op_u8=IdOpU8,op_role_base=OpRoleBase}, Bin8}.

%% 
req_test_x_x(Bin0) ->
	{IdU8, Bin1} = ?D(u8, Bin0),
	{IdU16, Bin2} = ?D(u16, Bin1),
	{IdU32, Bin3} = ?D(u32, Bin2),
	{RepeatIdU8Count, Bin4} = ?D(u16, Bin3),
	FunRepeatIdU8 = fun(_, {RepeatIdU8Acc, BinRepeatIdU8Acc}) ->
				{FunRepeatIdU8, BinRepeatIdU8Acc2} = ?D(u8, BinRepeatIdU8Acc),
				{[FunRepeatIdU8|RepeatIdU8Acc], BinRepeatIdU8Acc2}
			end,
	{RepeatIdU8, Bin5} = lists:foldl(FunRepeatIdU8, {[], Bin4}, lists:duplicate(RepeatIdU8Count, 0)),
	{OptionalIdU8Flag, Bin6} = ?D(u8, Bin5),
	{OptionalIdU8, Bin7} =
	case OptionalIdU8Flag of
		0 ->
			{undefined, Bin6};
		1 ->
			?D(u8, Bin6)
	end,
	#req_test_x_x{id_u8=IdU8,id_u16=IdU16,id_u32=IdU32,repeat_id_u8=RepeatIdU8,optional_id_u8=OptionalIdU8}.

%% 
ack_test_x_x(#ack_test_x_x{id_u8=IdU8,id_u16=IdU16,id_u32=IdU32,repeat_id_u8=RepeatIdU8,optional_id_u8=OptionalIdU8}) ->
	Bin1 = ?E(u8, IdU8),
	Bin2 = ?E(u16, IdU16),
	Bin3 = ?E(u32, IdU32),
	FunRepeatIdU8 = fun(FRepeatIdU8, {CountAcc, BinAcc}) ->
			FBin = ?E(u8, FRepeatIdU8),
			{CountAcc + 1, <<BinAcc/binary,FBin/binary>>}
	end,
	{CountRepeatIdU8, BinRepeatIdU8} = lists:foldl(FunRepeatIdU8, {0, <<>>}, RepeatIdU8),
	Bin4 = ?E(u16, CountRepeatIdU8),
	Bin5 = BinRepeatIdU8,
	Bin6 = 
		case OptionalIdU8 of
			undefined ->
				?E(u8, 0);
			_ ->
				BinOptionalIdU8Flag = ?E(u8, 1),
				BinOptionalIdU8= ?E(u8, OptionalIdU8),
				<<BinOptionalIdU8Flag/binary,BinOptionalIdU8/binary>>
		end,
	BinData = <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary,Bin5/binary,Bin6/binary>>,
	?MSG(40050, BinData).

%% 
req_test_php(Bin0) ->
	{U64, Bin1} = ?D(u64, Bin0),
	{Strxx, Bin2} = ?D(string, Bin1),
	{MsgReq, Bin3} = msg_test_php_decode(Bin2),
	{MsgOptFlag, Bin4} = ?D(u8, Bin3),
	{MsgOpt, Bin5} =
	case MsgOptFlag of
		0 ->
			{undefined, Bin4};
		1 ->
			msg_test_php_decode(Bin4)
	end,
	{MsgRepCount, Bin6} = ?D(u16, Bin5),
	FunMsgRep = fun(_, {MsgRepAcc, BinMsgRepAcc}) ->
				{FunMsgRep, BinMsgRepAcc2} = msg_test_php_decode(BinMsgRepAcc),
				{[FunMsgRep|MsgRepAcc], BinMsgRepAcc2}
			end,
	{MsgRep, Bin7} = lists:foldl(FunMsgRep, {[], Bin6}, lists:duplicate(MsgRepCount, 0)),
	#req_test_php{u64=U64,strxx=Strxx,msg_req=MsgReq,msg_opt=MsgOpt,msg_rep=MsgRep}.

%% 
ack_test_php_ok(#ack_test_php_ok{u64=U64,strxx=Strxx,msg_req=MsgReq,msg_opt=MsgOpt,msg_rep=MsgRep}) ->
	Bin1 = ?E(u64, U64),
	Bin2 = ?E(string, Strxx),
	Bin3 = msg_test_php_encode(MsgReq),
	Bin4 = 
		case MsgOpt of
			undefined ->
				?E(u8, 0);
			_ ->
				BinMsgOptFlag = ?E(u8, 1),
				BinMsgOpt = msg_test_php_encode(MsgOpt),
				<<BinMsgOptFlag/binary,BinMsgOpt/binary>>
		end,
	FunMsgRep = fun(FMsgRep, {CountAcc, BinAcc}) ->
			FBin = msg_test_php_encode(FMsgRep),
			{CountAcc + 1, <<BinAcc/binary,FBin/binary>>}
	end,
	{CountMsgRep, BinMsgRep} = lists:foldl(FunMsgRep, {0, <<>>}, MsgRep),
	Bin5 = ?E(u16, CountMsgRep),
	Bin6 = BinMsgRep,
	BinData = <<Bin1/binary,Bin2/binary,Bin3/binary,Bin4/binary,Bin5/binary,Bin6/binary>>,
	?MSG(40070, BinData).

%% 
req_test_js(Bin0) ->
	{U64, Bin1} = ?D(u64, Bin0),
	{I64, Bin2} = ?D(i64, Bin1),
	#req_test_js{u64=U64,i64=I64}.

%% 
ack_test_js_ok(#ack_test_js_ok{u64=U64,i64=I64}) ->
	Bin1 = ?E(u64, U64),
	Bin2 = ?E(i64, I64),
	BinData = <<Bin1/binary,Bin2/binary>>,
	?MSG(40090, BinData).

%% 
msg_test_php_encode(#msg_test_php{u16=U16}) ->
	Bin1 = ?E(u16, U16),
	<<Bin1/binary>>.
msg_test_php_decode(Bin0) ->
	{U16, Bin1} = ?D(u16, Bin0),
	{#msg_test_php{u16=U16}, Bin1}.
