add_custom_target(libc_sys_socket_unittests)

add_libc_unittest(
  socket_test
  SUITE
    libc_sys_socket_unittests
  SRCS
    socket_test.cpp
  DEPENDS
    libc.include.sys_socket
    libc.src.errno.errno
    libc.src.sys.socket.socket
    libc.src.unistd.close
)


add_libc_unittest(
  bind_test
  SUITE
    libc_sys_socket_unittests
  SRCS
    bind_test.cpp
  DEPENDS
    libc.include.sys_socket
    libc.src.errno.errno
    libc.src.sys.socket.socket
    libc.src.sys.socket.bind
    libc.src.stdio.remove
    libc.src.unistd.close
)
