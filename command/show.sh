# -*- shell-script -*-
# show.sh - Show debugger settings
#
#   Copyright (C) 2008 Rocky Bernstein rocky@gnu.org
#
#   zshdb is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2, or (at your option) any later
#   version.
#
#   zshdb is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#   
#   You should have received a copy of the GNU General Public License along
#   with zshdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

# Sets whether or not to display command to be executed in debugger prompt.
# If yes, always show. If auto, show only if the same line is to be run
# but the command is different.
typeset _Dbg_show_command="auto"

_Dbg_help_add show ''  # Help routine is elsewhere

_Dbg_do_show() {
  typeset show_cmd=$1
  typeset label=$2

  # Warranty, copying, directories, and aliases are omitted below.
  typeset -r subcmds="args basename debugger prompt"

  if [[ -z $show_cmd ]] ; then 
      typeset thing
      for thing in $subcmds ; do 
	_Dbg_do_show $thing 1
      done
      return 0
  fi

  case $show_cmd in 
    al | ali | alia | alias | aliase | aliases )
      unsetopt ksharrays
      for alias in ${(ki)_Dbg_aliases} ; do
	  _Dbg_msg "\t${alias}\t${_Dbg_aliases[$alias]}"
      done
      setopt ksharrays
      return 0
      ;;
    ar | arg | args )
      [[ -n $label ]] && label='args:     '
      _Dbg_msg \
"${label}Argument list to give script when debugged program starts is:\n" \
"      \"${_Dbg_script_args[@]}\"."
      return 0
      ;;
#     an | ann | anno | annot | annota | annotat | annotate )
#       [[ -n $label ]] && label='annotate: '
#      _Dbg_msg \
# "${label}Annotation_level is $_Dbg_annotate."
#       return 0
#       ;;
#     au | aut | auto | autoe | autoev | autoeva | autoeval )
#       [[ -n $label ]] && label='basename: '
#       _Dbg_msg \
# "${label}Evaluate unrecognized commands is" `_Dbg_onoff $_Dbg_autoeval`
#       return 0
#       ;;
    b | ba | bas | base | basen | basena | basenam | basename )
      [[ -n $label ]] && label='basename: '
      _Dbg_msg \
"${label}Show short filenames (the basename) in debug output is" `_Dbg_onoff $_Dbg_basename_only`
      return 0
      ;;
    com | comm | comma | comman | command | commands )
      local -i default_hi_start=_Dbg_hi-1
      if ((default_hi_start < 0)) ; then default_hi_start=0 ; fi
      local hi_start=${2:-$default_hi_start}

      eval "$_seteglob"
      case $hi_start in
	+ )
	  ((hi_start=_Dbg_hi_last_stop-1))
	  ;;
	$int_pat | -$int_pat)
	    ;;
	* )
	   _Dbg_msg "Invalid parameter $hi_start. Need an integer or '+'"
      esac
      eval "$_resteglob"
      
      local -i hi_stop=hi_start-10
      _Dbg_do_history_list $hi_start $hi_stop
      _Dbg_hi_last_stop=$hi_stop
      return 0
      ;;
    cop | copy| copyi | copyin | copying )
      _Dbg_msg \
"
		    GNU GENERAL PUBLIC LICENSE
		       Version 2, June 1991

 Copyright (C) 1989, 1991 Free Software Foundation, Inc.
                       59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

			    Preamble

  The licenses for most software are designed to take away your
freedom to share and change it.  By contrast, the GNU General Public
License is intended to guarantee your freedom to share and change free
software--to make sure the software is free for all its users.  This
General Public License applies to most of the Free Software
Foundation's software and to any other program whose authors commit to
using it.  (Some other Free Software Foundation software is covered by
the GNU Library General Public License instead.)  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
this service if you wish), that you receive source code or can get it
if you want it, that you can change the software or use pieces of it
in new free programs; and that you know you can do these things.

  To protect your rights, we need to make restrictions that forbid
anyone to deny you these rights or to ask you to surrender the rights.
These restrictions translate to certain responsibilities for you if you
distribute copies of the software, or if you modify it.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must give the recipients all the rights that
you have.  You must make sure that they, too, receive or can get the
source code.  And you must show them these terms so they know their
rights.

  We protect your rights with two steps: (1) copyright the software, and
(2) offer you this license which gives you legal permission to copy,
distribute and/or modify the software.

  Also, for each author's protection and ours, we want to make certain
that everyone understands that there is no warranty for this free
software.  If the software is modified by someone else and passed on, we
want its recipients to know that what they have is not the original, so
that any problems introduced by others will not reflect on the original
authors' reputations.

  Finally, any free program is threatened constantly by software
patents.  We wish to avoid the danger that redistributors of a free
program will individually obtain patent licenses, in effect making the
program proprietary.  To prevent this, we have made it clear that any
patent must be licensed for everyone's free use or not licensed at all.

  The precise terms and conditions for copying, distribution and
modification follow.

		    GNU GENERAL PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. This License applies to any program or other work which contains
a notice placed by the copyright holder saying it may be distributed
under the terms of this General Public License.  The \"Program\", below,
refers to any such program or work, and a \"work based on the Program\"
means either the Program or any derivative work under copyright law:
that is to say, a work containing the Program or a portion of it,
either verbatim or with modifications and/or translated into another
language.  (Hereinafter, translation is included without limitation in
the term \"modification\".)  Each licensee is addressed as \"you\".

Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running the Program is not restricted, and the output from the Program
is covered only if its contents constitute a work based on the
Program (independent of having been made by running the Program).
Whether that is true depends on what the Program does.

  1. You may copy and distribute verbatim copies of the Program's
source code as you receive it, in any medium, provided that you
conspicuously and appropriately publish on each copy an appropriate
copyright notice and disclaimer of warranty; keep intact all the
notices that refer to this License and to the absence of any warranty;
and give any other recipients of the Program a copy of this License
along with the Program.

You may charge a fee for the physical act of transferring a copy, and
you may at your option offer warranty protection in exchange for a fee.

  2. You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications or work under the terms of Section 1
above, provided that you also meet all of these conditions:

    a) You must cause the modified files to carry prominent notices
    stating that you changed the files and the date of any change.

    b) You must cause any work that you distribute or publish, that in
    whole or in part contains or is derived from the Program or any
    part thereof, to be licensed as a whole at no charge to all third
    parties under the terms of this License.

    c) If the modified program normally reads commands interactively
    when run, you must cause it, when started running for such
    interactive use in the most ordinary way, to print or display an
    announcement including an appropriate copyright notice and a
    notice that there is no warranty (or else, saying that you provide
    a warranty) and that users may redistribute the program under
    these conditions, and telling the user how to view a copy of this
    License.  (Exception: if the Program itself is interactive but
    does not normally print such an announcement, your work based on
    the Program is not required to print an announcement.)

These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it.

Thus, it is not the intent of this section to claim rights or contest
your rights to work written entirely by you; rather, the intent is to
exercise the right to control the distribution of derivative or
collective works based on the Program.

In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

  3. You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following:

    a) Accompany it with the complete corresponding machine-readable
    source code, which must be distributed under the terms of Sections
    1 and 2 above on a medium customarily used for software interchange; or,

    b) Accompany it with a written offer, valid for at least three
    years, to give any third party, for a charge no more than your
    cost of physically performing source distribution, a complete
    machine-readable copy of the corresponding source code, to be
    distributed under the terms of Sections 1 and 2 above on a medium
    customarily used for software interchange; or,

    c) Accompany it with the information you received as to the offer
    to distribute corresponding source code.  (This alternative is
    allowed only for noncommercial distribution and only if you
    received the program in object code or executable form with such
    an offer, in accord with Subsection b above.)

The source code for a work means the preferred form of the work for
making modifications to it.  For an executable work, complete source
code means all the source code for all modules it contains, plus any
associated interface definition files, plus the scripts used to
control compilation and installation of the executable.  However, as a
special exception, the source code distributed need not include
anything that is normally distributed (in either source or binary
form) with the major components (compiler, kernel, and so on) of the
operating system on which the executable runs, unless that component
itself accompanies the executable.

If distribution of executable or object code is made by offering
access to copy from a designated place, then offering equivalent
access to copy the source code from the same place counts as
distribution of the source code, even though third parties are not
compelled to copy the source along with the object code.

  4. You may not copy, modify, sublicense, or distribute the Program
except as expressly provided under this License.  Any attempt
otherwise to copy, modify, sublicense or distribute the Program is
void, and will automatically terminate your rights under this License.
However, parties who have received copies, or rights, from you under
this License will not have their licenses terminated so long as such
parties remain in full compliance.

  5. You are not required to accept this License, since you have not
signed it.  However, nothing else grants you permission to modify or
distribute the Program or its derivative works.  These actions are
prohibited by law if you do not accept this License.  Therefore, by
modifying or distributing the Program (or any work based on the
Program), you indicate your acceptance of this License to do so, and
all its terms and conditions for copying, distributing or modifying
the Program or works based on it.

  6. Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License.

  7. If, as a consequence of a court judgment or allegation of patent
infringement or for any other reason (not limited to patent issues),
conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot
distribute so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you
may not distribute the Program at all.  For example, if a patent
license would not permit royalty-free redistribution of the Program by
all those who receive copies directly or indirectly through you, then
the only way you could satisfy both it and this License would be to
refrain entirely from distribution of the Program.

If any portion of this section is held invalid or unenforceable under
any particular circumstance, the balance of the section is intended to
apply and the section as a whole is intended to apply in other
circumstances.

It is not the purpose of this section to induce you to infringe any
patents or other property right claims or to contest validity of any
such claims; this section has the sole purpose of protecting the
integrity of the free software distribution system, which is
implemented by public license practices.  Many people have made
generous contributions to the wide range of software distributed
through that system in reliance on consistent application of that
system; it is up to the author/donor to decide if he or she is willing
to distribute software through any other system and a licensee cannot
impose that choice.

This section is intended to make thoroughly clear what is believed to
be a consequence of the rest of this License.

  8. If the distribution and/or use of the Program is restricted in
certain countries either by patents or by copyrighted interfaces, the
original copyright holder who places the Program under this License
may add an explicit geographical distribution limitation excluding
those countries, so that distribution is permitted only in or among
countries not thus excluded.  In such case, this License incorporates
the limitation as if written in the body of this License.

  9. The Free Software Foundation may publish revised and/or new versions
of the General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

Each version is given a distinguishing version number.  If the Program
specifies a version number of this License which applies to it and \"any
later version\", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation.  If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
Foundation.

  10. If you wish to incorporate parts of the Program into other free
programs whose distribution conditions are different, write to the author
to ask for permission.  For software which is copyrighted by the Free
Software Foundation, write to the Free Software Foundation; we sometimes
make exceptions for this.  Our decision will be guided by the two goals
of preserving the free status of all derivatives of our free software and
of promoting the sharing and reuse of software generally.
"
      return 0
      ;;
#     e | ed | edi | edit | editi | editin | editing )
#       [[ -n $label ]] && label='editing:  '
#       local onoff="on."
#       [[ -z $_Dbg_edit ]] && onoff='off.'
#      _Dbg_msg \
# "${label}Editing of command lines as they are typed is" $onoff
#       return 0
#       ;;
    de|deb|debu|debug|debugg|debugger|debuggi|debuggin|debugging )
      local onoff=${1:-'on'}
      [[ -n $label ]] && label='debugger: '
      local onoff="off."
      (( $_Dbg_debug_debugger )) && onoff='on.'
     _Dbg_msg \
"${label}Allow debugging the debugger is" $onoff
      return 0
      ;;
    di|dir|dire|direc|direct|directo|director|directori|directorie|directories)
      local list=${_Dbg_dir[0]}
      local -i n=${#_Dbg_dir[@]}
      local -i i
      for (( i=1 ; i < n; i++ )) ; do
	list="${list}:${_Dbg_dir[i]}"
      done

     _Dbg_msg "Source directories searched: $list"
      return 0
      ;;
    hi|his|hist|histo|histor|history)
      _Dbg_msg \
"filename: The filename in which to record the command history is $_Dbg_histfile"
      _Dbg_msg \
"save: Saving of history save is" $(_Dbg_onoff $_Dbg_history_save)
      _Dbg_msg \
"size: Debugger history size is $_Dbg_history_length"
      ;;

#     lin | line | linet | linetr | linetra | linetrac | linetrace )
#       [[ -n $label ]] && label='line tracing: '
#       local onoff="off."
#       (( $_Dbg_linetrace != 0 )) && onoff='on.'
#       _Dbg_msg \
# "${label}Show line tracing is" $onoff
#       _Dbg_msg \
# "${label}Show line trace delay is ${_Dbg_linetrace_delay}."
#       return 0
#       ;;

#     lis | list | lists | listsi | listsiz | listsize )
#       [[ -n $label ]] && label='listsize: '
#      _Dbg_msg \
# "${label}Number of source lines zshdb will list by default is" \
#       "$_Dbg_listsize."
#       return 0
#       ;;

    lo | log | logg | loggi | loggin | logging )
      shift
      _Dbg_do_show_logging $*
      ;;
    p | pr | pro | prom | promp | prompt )
      [[ -n $label ]] && label='prompt:   '
      _Dbg_msg \
"${label}zshdb's prompt is:\n" \
"      \"$_Dbg_prompt_str\"."
      return 0
      ;;
    sho|show|showc|showco|showcom|showcomm|showcomma|showcomman|showcommand )
      [[ -n $label ]] && label='showcommand: '
     _Dbg_msg \
"${label}Show commands in debugger prompt is" \
      "$_Dbg_show_command."
      return 0
      ;;
    t|tr|tra|trac|trace|trace-|tracec|trace-co|trace-com|trace-comm|trace-comma|trace-comman|trace-command|trace-commands )
      [[ -n $label ]] && label='trace-commands: '
     _Dbg_msg \
"${label}State of command tracing is" \
      "$_Dbg_trace_commands."
      return 0
      ;;
    v | ve | ver | vers | versi | versio | version )
      _Dbg_do_show_versions
      return 0
      ;;
    w | wa | war | warr | warra | warran | warrant | warranty )
      _Dbg_do_info warranty
      return 0
      ;;
    *)
      _Dbg_msg "Don't know how to show $show_cmd."
      return 1
  esac
}

_Dbg_do_show_versions()
{
  _Dbg_printf "%-12s => $_Dbg_release" "Release"
  _Dbg_msg "=================================================================="
  if [[ -n $_Dbg_script ]] ; then
    _Dbg_printf "%-12s => $_Dbg_ver", 'zshdb'
    local version
    for file in $_Dbg_includes; do
      local set_version_cmd="version=\$_Dbg_${file}_ver"
      eval $set_version_cmd
      _Dbg_printf "%-12s => $version" $file
    done
  fi
}
