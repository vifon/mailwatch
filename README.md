NAME
====

mailwatch

SYNOPSIS
========

    mailwatch [ options ... ]

DESCRIPTION
===========

Passive mailbox monitoring.

When the new mail is downloaded to _MAILDIR/*/new_ , mailwatch sends a line "MAIL" to _/tmp/mailwatch_ pipe. If such pipe does not exist, it is created. Default maildir - _$HOME/mail_.

OPTIONS
=======


    --dir  DIR, -d DIR
    --mail DIR, -m DIR

The maildir path. Default: _$HOME/mail_


    --pipe PATH, -p PATH

The output pipe path. Default: _/tmp/mailwatch_


    --umask MASK

umask of the created pipes and lock files. Default: 0177

*Probably not working, not tested.*


    --clean, -c

Delete the used pipe on exit. Default: false


AUTHOR
======

Wojciech 'vifon' Siewierski

COPYRIGHT
=========

Copyright (C) 2012  Wojciech Siewierski

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
