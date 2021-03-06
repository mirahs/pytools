%% -*- coding: latin-1 -*-
-module(client).

-export([
	start/0
]).

-include("common.hrl").
-include("pb.hrl").


%%%===================================================================
%%% API
%%%===================================================================

start() ->
	{ok, Socket}   = gen_tcp:connect(?HOST, ?PORT, [binary, {packet,0},{active,true}]),
	?DEBUG("服务端连接"),
	send(Socket),
	recv(Socket).


send(Socket) ->
	send(Socket, pack(?p_role_login, {<<"admin">>, <<"admin">>})).


recv(Socket) ->
	recv(Socket, <<>>).

recv(Socket, Bin) ->
	receive
		{tcp, Socket, BinRecv} ->
			Bin2 = work(Socket, <<Bin/binary, BinRecv/binary>>),
			recv(Socket, Bin2);
		{tcp_closed, Socket} ->
			?DEBUG("服务端断开"),
			gen_tcp:close(Socket);
        {inet_reply, _Socket, ok} ->
            recv(Socket, Bin);
		_Other ->
			?DEBUG("服务端接收未知消息:~p", [_Other]),
			recv(Socket, Bin)
	end.


%%%===================================================================
%%% 路由处理
%%%===================================================================

%% 解包
work(Socket, <<Len:16/big-integer-unsigned, BinData:Len/binary, BinAcc/binary>>) ->
    <<PacketId:16/big-integer-unsigned, BinData2/binary>> = BinData,
    routing(PacketId, BinData2, Socket),
    work(Socket, BinAcc);
work(_Socket, BinAcc) ->
    BinAcc.

%% 路由处理
routing(PacketId, BinData, Socket) ->
    case module(PacketId) of
        {ok, Proto} ->
            ?DEBUG("routing PacketId:~w, Proto:~p, BinData:~w", [PacketId, Proto, BinData]),
            case Proto:unpack(PacketId, BinData) of
                {ok, Data} -> rpc(PacketId, Data, Socket);
                {error, _Error} -> ?DEBUG("PacketId:~w unpack 错误:~p", [PacketId, _Error])
            end;
        {error, _Error} -> ?DEBUG("PacketId:~w 路由 错误:~p", [PacketId, _Error])
    end.


%% rpc处理
rpc(?p_role_login_ok, Data, _Socket) ->
    ?DEBUG("p_role_login_ok Data:~p~n", [Data]);
rpc(?p_goods_item, Data, _Socket) ->
    ?DEBUG("p_goods_item Data:~p~n", [Data]);
rpc(PacketId, Data, _Socket) ->
    ?DEBUG("Unknow PacketId:~w Data:~w~n", [PacketId, Data]).


%%%===================================================================
%%% Internal functions
%%%===================================================================

module(Cmd) -> code(Cmd div 1000).

%% 协议映射
code(1) -> {ok, pb_role};
code(2) -> {ok, pb_goods};

%% 未知编号
code(Code) -> {error, Code}.

pack(Cmd, Data) ->
    case module(Cmd) of
        {ok, Proto} ->
            case catch Proto:pack(Cmd, Data) of
                {ok, Bin} -> {ok, Bin};
                _Err ->
                    ?DEBUG("打包数据出错[Cmd:~w][Data:~w][Reason:~w]", [Cmd, Data, _Err]),
                    {error, "打包数据时发生异常"}
            end;
        {error, _Code} ->
            ?DEBUG("模块影射失败[~w]:~w", [Cmd, Data]),
            {error, "打包数据时发生异常"}
    end.

%% 发送消息
send(Socket, {ok, Bin}) ->
    pb:send(Socket, Bin);
send(Socket, Bin) ->
    pb:send(Socket, Bin).
