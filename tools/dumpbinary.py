#!/usr/bin/env python

# Copyright (c) 2014-2021, Alessandro Gatti - frob.it
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

from __future__ import print_function

import argparse
import sys

DESCRIPTION = 'Dumps given data as a list of binary values of arbitrary length'
NAME = 'dumpbinary'
LITTLE_ENDIAN = 0
BIG_ENDIAN = 1
BOTH_ENDIAN = 2


def print_big_endian(strip_spaces, *data):
    output = ''

    for byte in data:
        fragment = '{:08b} '.format(byte)
        if strip_spaces:
            output += fragment.strip()
        else:
            output += fragment
    return output.strip()


def print_little_endian(strip_spaces, *data):
    output = ''

    for byte in reversed(data):
        fragment = '{:08b} '.format(byte)
        if strip_spaces:
            output += fragment.strip()
        else:
            output += fragment
    return output.strip()


def print_line(strip_spaces, offset, endian, *data):
    output = '{:08X}: '.format(offset)

    if endian == BIG_ENDIAN:
        print(print_big_endian(strip_spaces, *data))
    elif endian == LITTLE_ENDIAN:
        print(print_little_endian(strip_spaces, *data))
    elif endian == BOTH_ENDIAN:
        print('%s | %s' % (print_big_endian(strip_spaces, *data),
                           print_little_endian(strip_spaces, *data)))


def dump_byte(input_file):
    offset = 0
    while True:
        byte = input_file.read(1)
        if len(byte) == 0:
            break
        print_line(False, offset, ord(byte))
        offset += 1


def dump_word(input_file, endian, strip_spaces):
    offset = 0
    while True:
        word = input_file.read(2)
        if len(word) == 0:
            break
        elif len(word) == 1:
            raise Exception('Unaligned data')
        else:
            print_line(strip_spaces, offset, endian, ord(word[0]),
                       ord(word[1]))
        offset += 2


def dump_dword(input_file, endian, strip_spaces):
    offset = 0
    while True:
        dword = input_file.read(4)
        if len(dword) == 0:
            break
        elif len(dword) != 4:
            raise Exception('Unaligned data')
        else:
            print_line(strip_spaces, offset, endian, ord(dword[0]),
                       ord(dword[1]), ord(dword[2]), ord(dword[3]))
        offset += 4


def dump(input_file, length, endian, strip_spaces):
    if length == 1:
        dump_byte(input_file)
    elif length == 2:
        dump_word(input_file, endian, strip_spaces)
    elif length == 4:
        dump_dword(input_file, endian, strip_spaces)
    else:
        pass
    return 0


if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog=NAME, description=DESCRIPTION)
    endianness = parser.add_mutually_exclusive_group(required=True)
    endianness.add_argument('--endian', metavar='endian',
                            choices=('little', 'big', 'l', 'b'),
                            help='endianness of the input data')
    endianness.add_argument('-l', '--little',
                            help='shortcut for --endian little',
                            action='store_true')
    endianness.add_argument('-b', '--big', help='shortcut for --endian big',
                            action='store_true')
    endianness.add_argument('--both', action='store_true',
                            help='show both endianness data side by side')
    parser.add_argument('-c', '--compact', action='store_true',
                        help='do not print spaces between bytes')
    parser.add_argument('length', metavar='length', type=int,
                        choices=(1, 2, 4),
                        help='length in bytes of the binary values')
    parser.add_argument('infile', metavar='input_file', nargs='?',
                        type=argparse.FileType('r'), default=sys.stdin,
                        help='the file to read from, or STDIN')
    parser.add_argument('--version', action='version', version='0.0.1')

    arguments = parser.parse_args()
    endian = None
    if arguments.both:
        endian = BOTH_ENDIAN
    elif arguments.big or arguments.endian in ('big', 'b'):
        endian = BIG_ENDIAN
    else:
        endian = LITTLE_ENDIAN

    sys.exit(dump(arguments.infile, arguments.length, endian,
                  arguments.compact))
