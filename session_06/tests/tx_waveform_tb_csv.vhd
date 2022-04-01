


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.tx_waveform_IO_pgk.all;


entity tx_waveform_reader_et  is
    generic (
        FileName : string := "./tx_waveform_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out tx_waveform_reader_rec
    );
end entity;   

architecture Behavioral of tx_waveform_reader_et is 

  constant  NUM_COL    : integer := 9;
  signal    csv_r_data : c_integer_array(NUM_COL -1 downto 0)  := (others=>0)  ;
begin

  csv_r :entity  work.csv_read_file 
    generic map (
        FileName =>  FileName, 
        NUM_COL => NUM_COL,
        useExternalClk=>true,
        HeaderLines =>  2
    ) port map (
        clk => clk,
        Rows => csv_r_data
    );

  csv_from_integer(csv_r_data(0), data.globals.clk);
  csv_from_integer(csv_r_data(1), data.globals.rst);
  csv_from_integer(csv_r_data(2), data.globals.reg.address);
  csv_from_integer(csv_r_data(3), data.globals.reg.value);
  csv_from_integer(csv_r_data(4), data.globals.reg.new_value);
  csv_from_integer(csv_r_data(5), data.data_in_m2s.last);
  csv_from_integer(csv_r_data(6), data.data_in_m2s.valid);
  csv_from_integer(csv_r_data(7), data.data_in_m2s.data);
  csv_from_integer(csv_r_data(8), data.tx_bus_m2s.shiftregister.data_out);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.tx_waveform_IO_pgk.all;

entity tx_waveform_writer_et  is
    generic ( 
        FileName : string := "./tx_waveform_out.csv"
    ); port (
        clk : in std_logic ;
        data : in tx_waveform_writer_rec
    );
end entity;

architecture Behavioral of tx_waveform_writer_et is 
  constant  NUM_COL : integer := 23;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "globals_clk; globals_rst; globals_reg_address; globals_reg_value; globals_reg_new_value; data_in_m2s_last; data_in_m2s_valid; data_in_m2s_data; data_in_s2m_ready; tx_bus_s2m_samplingsignals_clr; tx_bus_s2m_samplingsignals_read_enable; tx_bus_s2m_samplingsignals_ramp; tx_bus_s2m_samplingsignals_read_column_select_s; tx_bus_s2m_samplingsignals_read_row_select_s; tx_bus_s2m_writesignals_writeenable_2; tx_bus_s2m_writesignals_writeenable_1; tx_bus_s2m_writesignals_clear; tx_bus_s2m_shiftregister_sr_clock; tx_bus_s2m_shiftregister_sampleselectany; tx_bus_s2m_shiftregister_sr_select; tx_bus_s2m_shiftregister_sampleselect; tx_bus_s2m_shiftregister_sr_clear; tx_bus_m2s_shiftregister_data_out",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.globals.clk, data_int(0) );
  csv_to_integer(data.globals.rst, data_int(1) );
  csv_to_integer(data.globals.reg.address, data_int(2) );
  csv_to_integer(data.globals.reg.value, data_int(3) );
  csv_to_integer(data.globals.reg.new_value, data_int(4) );
  csv_to_integer(data.data_in_m2s.last, data_int(5) );
  csv_to_integer(data.data_in_m2s.valid, data_int(6) );
  csv_to_integer(data.data_in_m2s.data, data_int(7) );
  csv_to_integer(data.data_in_s2m.ready, data_int(8) );
  csv_to_integer(data.tx_bus_s2m.samplingsignals.clr, data_int(9) );
  csv_to_integer(data.tx_bus_s2m.samplingsignals.read_enable, data_int(10) );
  csv_to_integer(data.tx_bus_s2m.samplingsignals.ramp, data_int(11) );
  csv_to_integer(data.tx_bus_s2m.samplingsignals.read_column_select_s, data_int(12) );
  csv_to_integer(data.tx_bus_s2m.samplingsignals.read_row_select_s, data_int(13) );
  csv_to_integer(data.tx_bus_s2m.writesignals.writeenable_2, data_int(14) );
  csv_to_integer(data.tx_bus_s2m.writesignals.writeenable_1, data_int(15) );
  csv_to_integer(data.tx_bus_s2m.writesignals.clear, data_int(16) );
  csv_to_integer(data.tx_bus_s2m.shiftregister.sr_clock, data_int(17) );
  csv_to_integer(data.tx_bus_s2m.shiftregister.sampleselectany, data_int(18) );
  csv_to_integer(data.tx_bus_s2m.shiftregister.sr_select, data_int(19) );
  csv_to_integer(data.tx_bus_s2m.shiftregister.sampleselect, data_int(20) );
  csv_to_integer(data.tx_bus_s2m.shiftregister.sr_clear, data_int(21) );
  csv_to_integer(data.tx_bus_m2s.shiftregister.data_out, data_int(22) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.tx_waveform_IO_pgk.all;

entity tx_waveform_tb_csv is 
end entity;

architecture behavior of tx_waveform_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : tx_waveform_reader_rec;
  signal data_out : tx_waveform_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.tx_waveform_reader_et 
    generic map (
        FileName => "./tx_waveform_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.tx_waveform_writer_et
    generic map (
        FileName => "./tx_waveform_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  
  data_out.globals.clk <=clk;
  data_out.globals.reg <= data_in.globals.reg;
  data_out.globals.rst <= data_in.globals.rst;
    data_out.data_in_m2s <= data_in.data_in_m2s;
  data_out.tx_bus_m2s <= data_in.tx_bus_m2s;


DUT :  entity work.tx_waveform  port map(

  globals => data_out.globals,
  data_in_m2s => data_out.data_in_m2s,
  data_in_s2m => data_out.data_in_s2m,
  tx_bus_s2m => data_out.tx_bus_s2m,
  tx_bus_m2s => data_out.tx_bus_m2s
    );

end behavior;
---------------------------------------------------------------------------------------------------
    