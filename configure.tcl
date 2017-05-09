#/*****************************************************************************/
# A tcl script for FPGA configuration                        Ryohei Kobayashi */
#                                                                  2017.05.10 */
#/*****************************************************************************/

### checking command line argument
if {$argc == 0} {
    puts "ERROR: specify bit file name with -tclargs"
    puts "Usage: vivado -mode batch -source configure.tcl -tclargs <bit file> <debug core file>"
    exit
}

# checking whether a specified bit file exists
set BIT_FILE [lindex $argv 0]
if {![file exists $BIT_FILE]} {
    puts "ERROR: bit file ' $BIT_FILE ' does not exist"
    exit
}

# checking whether a specified debug core exists
if {$argc > 1} {
    set DEBUG_CORE [lindex $argv 0]
    if {![file exists $DEBUG_CORE]} {
	puts "ERROR: debug core ' $DEBUG_CORE ' does not exist"
	exit
    }
} else {
    set DEBUG_CORE ""
    puts "no debug core is specified"
}

puts "bit file: $BIT_FILE"
puts "debug core: $DEBUG_CORE"


### starting configuration
# opening hardware
open_hw
connect_hw_server
open_hw_target

if {[llength get_hw_devices] == 0} {
    puts "ERROR: cannot open hardware"
    exit
}

set TARGET [lindex [get_hw_devices] 0]
puts "target device: $TARGET"

# setting the bit file and debug core
set_property PROGRAM.FILE $BIT_FILE $TARGET
set_property PROBES.FILE $DEBUG_CORE $TARGET

# configuration
current_hw_device $TARGET
refresh_hw_device -update_hw_probes false $TARGET
program_hw_devices $TARGET
refresh_hw_device $TARGET
