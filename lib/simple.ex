defmodule CarRadio do

  def start_station([_pid, station, name]) do
    IO.inspect('Starting Radio station')
    pid = CarRadio.start(name)
    PubSub.subscribe(pid, station);
    # Process.sleep(100);
    [pid, station, name]
  end
  def start(client_name) do spawn(fn -> loop(client_name) end) end
  def loop(name) do
    receive do # recieve is blocking.
      message -> IO.puts "#{name} received #{message}"; loop(name);
    end
  end
end

defmodule RadioTower do # RadioTower can be replaced with Postgrex.Notifications, walex, boltun
# https://hexdocs.pm/postgrex/Postgrex.Notifications.html#content
# https://github.com/cpursley/walex
  @spec power_on_radio_towers() :: list()
  def power_on_radio_towers do
    {:ok, _pid} = PubSub.start_link()
    [:fm600, :fm969TheEagle] |> Enum.with_index |> Enum.map(fn {station,i} ->
      stream(station, i*10000)
    end)
  end
  def stream(station, count) do
    spawn fn -> infinateStation(station, count) end
  end
  def infinateStation(station, count) do
    PubSub.publish(station, "#{station} is great! #{count}"); # 1. publish is used because it is non blocking.
    Process.sleep(10);
    infinateStation(station, count + 1)
  end

end

defmodule Narrator do
  def start() do
    RadioTower.power_on_radio_towers
    CarRadio.start_station([nil, :fm969TheEagle, "Nick"])
  end
end
'''
Narrator.start

'''
