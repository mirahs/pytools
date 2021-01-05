-module(pb_role).

-export([pack/2,msg/2,unpack/2]).


%% 登录成功
pack(1010 ,{Uname,GoodsItem}) ->
	Bin1 = ?E(string, Uname),
	FunGoodsItem = fun(FGoodsItem, {CountAcc, BinAcc}) ->
			FBin = pb_goods:pack_msg(3010, FGoodsItem),
			{CountAcc + 1, <<BinAcc/binary,FBin/binary>>}
	end,
	{CountGoodsItem, BinGoodsItem} = lists:foldl(FunGoodsItem, {0, <<>>}, GoodsItem),
	Bin2 = ?E(u16, CountGoodsItem),
	Bin3 = BinGoodsItem,
	BinData = <<Bin1/binary,Bin2/binary,Bin3/binary>>,
	{ok, ?MSG(1010, BinData)};

pack(_Cmd, _Data) -> 
	{error, {unknown_command, _Data}}.


%% 登录成功
msg(1010 ,{Uname,GoodsItem}) ->
	Bin1 = ?E(string, Uname),
	FunGoodsItem = fun(FGoodsItem, {CountAcc, BinAcc}) ->
			FBin = pb_goods:pack_msg(3010, FGoodsItem),
			{CountAcc + 1, <<BinAcc/binary,FBin/binary>>}
	end,
	{CountGoodsItem, BinGoodsItem} = lists:foldl(FunGoodsItem, {0, <<>>}, GoodsItem),
	Bin2 = ?E(u16, CountGoodsItem),
	Bin3 = BinGoodsItem,
	BinData = <<Bin1/binary,Bin2/binary,Bin3/binary>>,
	{ok, BinData};

msg(_Cmd, _Data) -> 
	{error, {unknown_command, _Data}}.


%% 登录成功
unpack(1010, _Bin0) ->
	{Uname, _Bin1} = ?D(string, _Bin0),
	{GoodsItemCount, _Bin2} = ?D(u16, _Bin1),
	FunGoodsItem = fun(_, {GoodsItemAcc, _BinGoodsItemAcc}) ->
				{FunGoodsItem, _BinGoodsItemAcc2} = pb_goods:unpack_msg(3010, _BinGoodsItemAcc),
				{[FunGoodsItem|GoodsItemAcc], _BinGoodsItemAcc2}
			end,
	{GoodsItemTmp, _Bin3} = lists:foldl(FunGoodsItem, {[], _Bin2}, lists:duplicate(GoodsItemCount, 0)),
	GoodsItem = lists:reverse(GoodsItemTmp),
	{ok, {Uname,GoodsItem}};

unpack(_Cmd, _Bin) -> 
	{error, {unknown_command, _Bin}}.
