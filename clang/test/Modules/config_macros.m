@import config;

int *test_foo(void) {
  return foo();
}

char *test_bar(void) {
  return bar(); // expected-error{{call to undeclared function 'bar'; ISO C99 and later do not support implicit function declarations}} \
                // expected-error{{incompatible integer to pointer conversion}}
}

#undef WANT_FOO // expected-note{{macro was #undef'd here}}
@import config; // expected-warning{{#undef of configuration macro 'WANT_FOO' has no effect on the import of 'config'; pass '-UWANT_FOO' on the command line to configure the module}}

#define WANT_FOO 2 // expected-note{{macro was defined here}}
@import config; // expected-warning{{definition of configuration macro 'WANT_FOO' has no effect on the import of 'config'; pass '-DWANT_FOO=...' on the command line to configure the module}}

#undef WANT_FOO
#define WANT_FOO 1
@import config; // okay

#define WANT_BAR 1 // expected-note{{macro was defined here}}
@import config; // expected-warning{{definition of configuration macro 'WANT_BAR' has no effect on the import of 'config'; pass '-DWANT_BAR=...' on the command line to configure the module}}

// RUN: rm -rf %t
// RUN: %clang_cc1 -std=c99 -fmodules -fimplicit-module-maps -x objective-c -fmodules-cache-path=%t -DWANT_FOO=1 -emit-module -fmodule-name=config %S/Inputs/module.modulemap
// RUN: %clang_cc1 -std=c99 -fmodules -fimplicit-module-maps -fmodules-cache-path=%t -I %S/Inputs -DWANT_FOO=1 %s -verify

