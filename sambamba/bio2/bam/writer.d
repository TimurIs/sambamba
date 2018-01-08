/*
    New style BAM writer. This file is part of Sambamba.
    Copyright (C) 2017 Pjotr Prins <pjotr.prins@thebird.nl>

    Sambamba is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License,
    or (at your option) any later version.

    Sambamba is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
    02111-1307 USA

*/

module sambamba.bio2.bam.writer;

import std.conv;
import core.stdc.stdio: fopen, fread, fclose;
import std.exception;
import std.file;
import std.stdio;
import std.string;
import std.typecons;
import std.bitmanip;

import bio.bam.cigar;
import bio.bam.constants;

import sambamba.bio2.bgzf;
import sambamba.bio2.bgzf_writer;
import sambamba.bio2.constants;

import sambamba.bio2.bam.header;
import sambamba.bio2.bam.reader : ProcessReadBlob, Offset;

struct ModifyProcessReadBlob { // make this generic later
  ProcessReadBlob _read2;

  @property ubyte[] toBlob() {
    return _read2.toBlob();
  }

  @property void set_qc_fail() {
    auto data = _read2.toBlob;
    writeln(_read2._flag);
    // data[Offset.flag_nc] = data[Offset.flag_nc] & 0x200;
    // writeln(data[Offset.flag_nc]);
    // buf.write!(T,Endian.littleEndian)(value,0);
    uint flag_nc = _read2._flag_nc & 0x200ffff;
    data[Offset.flag_nc..$].write!(uint,Endian.littleEndian)(flag_nc,0);
  }
}

struct BamWriter {
  BgzfWriter bgzf_writer;

  this(string fn, ref BamHeader header, int compression_level = -1) {
    bgzf_writer = BgzfWriter(fn,compression_level);
    write_bam_header(bgzf_writer,header);
  }

}
