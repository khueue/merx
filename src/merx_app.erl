-module(merx_app).

-export([listen/1,loop/1]).

listen(Port) ->
    TcpOptions = [{packet,http}, {active,false}],
    {ok, LSocket} = gen_tcp:listen(Port, TcpOptions),
    accept(LSocket).

accept(LSocket) ->
    io:format("------- accepting ...~n"),
    {ok, Socket} = gen_tcp:accept(LSocket),
    spawn_link(?MODULE, loop, [Socket]),
    accept(LSocket).

loop(Socket) ->
    recv_headers(Socket),
    gen_tcp:send(
        Socket,
        "HTTP/1.1 200 OK\r\n" ++
        "Connection: close\r\n" ++
        "Content-Type: text/plain\r\n" ++ % application/octet-stream
        "Content-Length: 4\r\n" ++
        "\r\n" ++
        "aoeu"),
    gen_tcp:close(Socket).

recv_headers(Socket) ->
    case gen_tcp:recv(Socket, _UnusedWhenPassive=0) of
        {ok, http_eoh} ->
            io:format("### End-of-header~n"),
            ok;
        {ok, HttpPacket} ->
            io:format("### Header: ~p~n", [HttpPacket]),
            recv_headers(Socket)
    end.
