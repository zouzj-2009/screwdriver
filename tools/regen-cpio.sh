#!/bin/bash
out=all
echo "@@ Generate list.real.$out ..." >&2
./tools/getdir $PWD/initramfs/ > list.real.$out
echo "@@ Generate $out.cpio archive ..." >&2
./tools/gen_init_cpio list.real.$out >$out.cpio
