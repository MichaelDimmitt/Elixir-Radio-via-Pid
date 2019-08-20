defmodule Client do

  def start(client_name) do
    spawn(fn -> loop(client_name) end)
  end

  def loop(name) do
    receive do
      message ->
        IO.puts "#{name} received `#{message}`"
        loop(name)
    end
  end
  def runnn do
    {topic1, topic2} = {:erlang, :elixir}
    {:erlang, :elixir}
    {:ok, _pid} = PubSub.start_link()
    {pid1, pid2, pid3} = {
      Client.start("John"),
      Client.start("Nick"),
      Client.start("Tim")
    }
    PubSub.subscribe(pid1, topic1)
    PubSub.subscribe(pid3, topic2)
    PubSub.publish(topic1, "#{topic1} is great!")
    PubSub.publish(topic2, "#{topic2} is so cool, dude")
    PubSub.subscribe(pid2, topic1)
    PubSub.publish(topic1, "#{topic1} is great!")
    PubSub.subscribe(pid2, topic2)
  end

end
