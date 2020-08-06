# Set libraries
set merged_lef ./merged_unpadded.lef
read_liberty ./sky130_fd_sc_hd__ss_n40C_1v28.lib 
read_lef ${merged_lef}

read_verilog net.v
link_design test

# Test
create_clock -name c1 -period 10 clk
set flop [get_name [lindex [get_cells -of_objects [get_nets clk]] 0] ]
set clock_port [get_name [get_ports -of_object [get_net clk] -filter "direction == input"]]
puts "Testing Power on flop ${flop} for clock ${clock_port}"
foreach i {0 1 2 3 4 5 6 7 8 9 10} {
	# Set activity and report Power
	set_power_activity -pins ${flop}/D  -activity [expr 0.1 *[expr $i*$i]] -duty 0.5
	#set_power_activity -pins ${flop}/Q  -activity [expr 0.1 *[expr $i*$i]] -duty 0.5
	#set_power_activity -pins ${flop}/CLK  -activity [expr 0.1 *[expr $i*$i]] -duty 0.5
	with_output_to_variable r "report_power -instance ${flop} -digits 7"
	# grep cell name
	foreach l [split $r '\n'] { if { [regexp ${flop} $l ] } { puts $l} }
}
exit
