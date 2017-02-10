#/bin/sh

# Copyright (C) 2017, Isaac I.Y. Saito
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#   * Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#   * Neither the names of Stanford University or Open Source Robotics Foundation. nor the names of its
#     contributors may be used to endorse or promote products derived from
#     this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

function iterate_command {
  command=${1:-"rospack profile"};
  num_iteration=${2:-10000};
  for i in $(seq 1 ${num_iteration}); do
    echo "${i}th iteration.";
    "$command";
  done
}

function measure_performance {
  command=${1:-"rospack profile"};
  num_iteration=${2:-100000};
  output_filename=${3:-"straceResult_${command// /-}_${num_iteration}_`date +%Y%m%d%H%M%S`.log"};
  echo "Command to be measured: ${command}";

  export ROS_CACHE_TIMEOUT=0.0 # Needed to not use cache.

  # strace doesn't easily call a function. http://unix.stackexchange.com/questions/339173/strace-not-finding-shell-function-with-cant-stat-error
  strace -o ${output_filename} -c -Ttt bash -c "$(typeset -f iterate_command); iterate_command '${command}' $num_iteration";
}

command=${1:-"rospack profile"};
num_iteration=${2:-100000};
output_filename=${3:-"straceResult_${command// /-}_${num_iteration}_`date +%Y%m%d%H%M%S`.log"};
measure_performance "$command" $num_iteration $output_filename;
