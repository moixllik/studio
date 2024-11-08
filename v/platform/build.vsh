import os

fn sh(c string) {
  println('> ' + c)
  println(execute_or_exit(c).output)
}

my_os := $if windows { 'WINDOWS' } $else { 'UNIX' }

// BUILD LIB

sh('gcc -c ./c/lib.c -o ./c/unix.o')
sh('ar rcs ./c/libunix.a ./c/unix.o')

sh('x86_64-w64-mingw32-gcc -c ./c/lib.c -o ./c/win.o')
sh('ar rcs ./c/libwin.a ./c/win.o')

// BUILD APP

sh('v -prod -os windows -o app-win.exe src')
sh('v -prod -os linux -o app-unix.exe src')
sh('v -o app.exe src')

// EXECUTABLES

println(my_os + ' OS')
println(os.file_size('./app-win.exe').str() + ' win')
println(os.file_size('./app-unix.exe').str() + ' unix')
println(os.file_size('./app.exe').str() + ' debug')

// TEST

println('\nTest win')
if my_os == 'UNIX' {
  sh('wine ./app-win.exe')
} else {
  sh('./app-win.exe')
}

if my_os == 'UNIX' {
  println('Test unix')
  sh('./app-unix.exe')
}

println('Test debug')
sh('./app.exe')
