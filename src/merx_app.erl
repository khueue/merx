-module(merx_app).

-export([listen/1,loop/1]).

-include_lib("kernel/include/file.hrl").

listen(Port) ->
    TcpOptions = [{packet,http}, {active,false}],
    {ok, LSocket} = gen_tcp:listen(Port, TcpOptions),
    accept_loop(LSocket).

accept_loop(LSocket) ->
    io:format("------- Accepting ...~n"),
    {ok, Socket} = gen_tcp:accept(LSocket),
    spawn_link(?MODULE, loop, [Socket]),
    accept_loop(LSocket).

loop(Socket) ->
    recv_headers(Socket),
    FileName = "file.mkv",
    {ok, FileInfo} = file:read_file_info(FileName),
    ByteSize = integer_to_list(FileInfo#file_info.size),
    gen_tcp:send(
        Socket,
        "HTTP/1.1 200 OK\r\n" ++
        "Connection: close\r\n" ++
        "Content-Type: application/octet-stream\r\n" ++ % application/octet-stream
        "Content-Length: " ++ ByteSize ++ "\r\n" ++
        "\r\n"),
    send_file(Socket, FileName),
    gen_tcp:close(Socket).

send_file(Socket, File) ->
    {ok, Handle} = file:open(File, [read_ahead,raw,binary]),
    send_file_aux(Socket, Handle),
    file:close(Handle).

send_file_aux(Socket, Handle) ->
    case file:read(Handle, 8192) of
        {ok, Data} ->
            gen_tcp:send(Socket, Data),
            send_file_aux(Socket, Handle);
        eof ->
            ok
    end.

recv_headers(Socket) ->
    case gen_tcp:recv(Socket, _UnusedWhenPassive=0) of
        {ok, http_eoh} ->
            io:format("### End-of-header~n"),
            ok;
        {ok, HttpPacket} ->
            io:format("### Header: ~p~n", [HttpPacket]),
            recv_headers(Socket)
    end.
