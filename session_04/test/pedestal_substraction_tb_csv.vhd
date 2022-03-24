


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.pedestal_substraction_IO_pgk.all;


entity pedestal_substraction_reader_et  is
    generic (
        FileName : string := "./pedestal_substraction_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out pedestal_substraction_reader_rec
    );
end entity;   

architecture Behavioral of pedestal_substraction_reader_et is 

  constant  NUM_COL    : integer := 7;
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

  csv_from_integer(csv_r_data(0), data.clk);
  csv_from_integer(csv_r_data(1), data.ped_data);
  csv_from_integer(csv_r_data(2), data.ped_data_address);
  csv_from_integer(csv_r_data(3), data.data_in_m2s.last);
  csv_from_integer(csv_r_data(4), data.data_in_m2s.valid);
  csv_from_integer(csv_r_data(5), data.data_in_m2s.data);
  csv_from_integer(csv_r_data(6), data.data_out_s2m.ready);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.pedestal_substraction_IO_pgk.all;

entity pedestal_substraction_writer_et  is
    generic ( 
        FileName : string := "./pedestal_substraction_out.csv"
    ); port (
        clk : in std_logic ;
        data : in pedestal_substraction_writer_rec
    );
end entity;

architecture Behavioral of pedestal_substraction_writer_et is 
  constant  NUM_COL : integer := 11;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; ped_data; ped_data_address; data_in_m2s_last; data_in_m2s_valid; data_in_m2s_data; data_in_s2m_ready; data_out_m2s_last; data_out_m2s_valid; data_out_m2s_data; data_out_s2m_ready",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.ped_data, data_int(1) );
  csv_to_integer(data.ped_data_address, data_int(2) );
  csv_to_integer(data.data_in_m2s.last, data_int(3) );
  csv_to_integer(data.data_in_m2s.valid, data_int(4) );
  csv_to_integer(data.data_in_m2s.data, data_int(5) );
  csv_to_integer(data.data_in_s2m.ready, data_int(6) );
  csv_to_integer(data.data_out_m2s.last, data_int(7) );
  csv_to_integer(data.data_out_m2s.valid, data_int(8) );
  csv_to_integer(data.data_out_m2s.data, data_int(9) );
  csv_to_integer(data.data_out_s2m.ready, data_int(10) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.pedestal_substraction_IO_pgk.all;

entity pedestal_substraction_tb_csv is 
end entity;

architecture behavior of pedestal_substraction_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : pedestal_substraction_reader_rec;
  signal data_out : pedestal_substraction_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.pedestal_substraction_reader_et 
    generic map (
        FileName => "./pedestal_substraction_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.pedestal_substraction_writer_et
    generic map (
        FileName => "./pedestal_substraction_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.ped_data <= data_in.ped_data;
  data_out.ped_data_address <= data_in.ped_data_address;
  data_out.data_in_m2s <= data_in.data_in_m2s;
  data_out.data_out_s2m <= data_in.data_out_s2m;


DUT :  entity work.pedestal_substraction  port map(

  clk => clk,
  ped_data => data_out.ped_data,
  ped_data_address => data_out.ped_data_address,
  data_in_m2s => data_out.data_in_m2s,
  data_in_s2m => data_out.data_in_s2m,
  data_out_m2s => data_out.data_out_m2s,
  data_out_s2m => data_out.data_out_s2m
    );

end behavior;
---------------------------------------------------------------------------------------------------
    