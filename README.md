# cln_op
some core lightning op scripts:

== suez_compare.sh ==
Compares previous suez output to the current status
Prereq: suez (https://github.com/prusnak/suez)
Usage: run suez_compare.sh after editing suez dir (default $HOME/suez)
Outputs: creates 'statuses' directory with previous suez outputs stored in plain ascii, stores current status there, shows a diff between the last two statuses
