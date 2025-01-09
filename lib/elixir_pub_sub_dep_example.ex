defmodule CarRadio2 do
  def start(client_name) do spawn(fn -> loop(client_name) end) end
  def loop(name) do
    receive do
      message -> IO.puts "#{name} received #{message}"; loop(name);
    end
  end
  def start_station([_pid, station, name]) do
    IO.inspect('Starting Radio station')
    pid = CarRadio.start(name)
    PubSub.subscribe(pid, station);
    Process.sleep(100);
    [pid, station, name]
  end
  def stop_station([pid, prev_station, name]) do
    Process.sleep(100);
    PubSub.unsubscribe(pid, prev_station);
    Process.sleep(100);
    IO.inspect('Stopping Radio station')
    Process.sleep(10);
    [pid, prev_station, name]
  end
  def change_station([pid, prev_station, name], station) do
    Process.sleep(100);
    PubSub.unsubscribe(pid, prev_station);
    IO.inspect('Changing Radio station')
    Process.sleep(1000);
    PubSub.subscribe(pid, station);
    Process.sleep(100);
    [pid, station, name]
  end
  def default_turn_on_dumb_radio do
    [station | _tail] = Narrator.ask_stations()
    IO.inspect('Starting Radio station')
    pid = CarRadio.start('')
    PubSub.subscribe(pid, station);
    [pid, station, '']
  end
  # def instruction_manual do
  #   ensure radio station :fm969TheEagle has been created
  #   CarRadio.start_station([nil, :fm969TheEagle, "Nick"])
  #   |> CarRadio.change_station(:fm600)
  #   |> CarRadio.stop_station
  #   |> CarRadio.start_station
  #   |> CarRadio.stop_station
  # end
end

defmodule RadioStation2 do
  def stream(station, count) do
    spawn fn -> infinateStation(station, count) end
  end
  def stream2(station, count) do
    spawn fn ->
      Stream.cycle(1..10) |> Enum.map(fn _chunk ->
        PubSub.publish(station, "#{station} is great! #{count}");
        Process.sleep(10);
      end)
    end
  end
  def infinateStation(station, count) do
    PubSub.publish(station, "#{station} is great! #{count}");
    Process.sleep(10);
    infinateStation(station, count + 1)
  end
end

defmodule Narrator2 do
  # alias ElixirPubSubDepExample.CarRadio
  def ask_stations do
    [:fm600, :fm969TheEagle]
  end
  def power_on_radio_towers do
    {:ok, _pid} = PubSub.start_link()
    ask_stations() |> Enum.with_index |> Enum.map(fn {station,i} ->
      RadioStation.stream(station, i*10000)
    end)
    # RadioStation.stream(:fm600, 0);
    # RadioStation.stream(:fm969TheEagle, 999999)
  end
  def simple_car_radio do
    CarRadio.start_station([nil, :fm969TheEagle, "Nick"])
    |> CarRadio.change_station(:fm600)
    |> CarRadio.stop_station
    |> CarRadio.start_station
    |> CarRadio.stop_station
  end
  def complicatedRadio do
    {fm600, station2} = {:fm600, :fm969TheEagle}
    {car1, car2, car3} = {
      CarRadio.start_station([nil, station2, "Nick"]),
      CarRadio.start_station([nil, fm600, "Tim"]),
      CarRadio.start_station([nil, fm600, "John"])
    }

    spawn fn -> CarRadio.stop_station(car1) end
    spawn fn -> CarRadio.stop_station(car2) end

    CarRadio.change_station(car3, station2)
    |> CarRadio.stop_station
    |> CarRadio.start_station
    |> CarRadio.change_station(station2)
    |> CarRadio.stop_station
  end

  def complicatedRadioOld do
    {fm600, station2} = {:fm600, :fm969TheEagle}

    {car1, car2, car3} = {
      CarRadio.start_station([nil, station2, "Nick"]),
      CarRadio.start_station([nil, fm600, "Tim"]),
      CarRadio.start_station([nil, fm600, "John"])
    }
    _car1 = CarRadio.stop_station(car1);
    _car2 = CarRadio.stop_station(car2)

    car3 = CarRadio.change_station(car3, station2)
    _car3 = CarRadio.stop_station(car3)
    car3 = CarRadio.start_station([nil,fm600, "John"])
    car3 = CarRadio.change_station(car3, station2)
    _car3 = CarRadio.stop_station(car3)
  end


end
'''
Narrator.power_on_radio_towers
Narrator.simple_car_radio
Narrator.complicatedRadio
Narrator.complicatedRadioOld
CarRadio.start_station([nil, :fm969TheEagle, "Nick"]) |> CarRadio.change_station(:fm600)

Narrator.power_on_radio_towers
CarRadio.default_turn_on_dumb_radio
'''
