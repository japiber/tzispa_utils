module Tzispa
  module Utils

    class LRUCache

      attr_reader :size, :hash

      class DListQueue

        def initialize(size)
          @size = size
          @head = nil
          @tail = nil
          @counter = 0
        end

        def enqueue(node)
          @counter += 1
          if @head && @tail
            node.next = @head
            @head.prev = node
            @head = node
          else
            @head = @tail = node
          end
        end

        def dequeue()
          temp = @tail
          @tail.prev.next = nil
          @tail = @tail.prev
          @counter -= 1
          temp
        end

        def move_back(node)
          cur = node
          cur.prev&.next = cur.next
          cur.next&.prev = cur.prev
          node.next = @head
          @head.prev = node
          @head = node
        end

      end


      Node = Struct.new(:value, :next, :prev)

      def initialize(size)
        @size = size
        @hash = Hash.new
        @queue = DListQueue.new(size)
      end

      def get(key)
        @hash[key]&.tap { |value|
          update_access_table(value[1])
        }
      end

      def set(key, value)
        remove_least_accesed if @hash.length > @size-1
        if @hash[key]
          @hash[key][0] = value
        else
          Node.new(key).tap { |node|
            @hash[key] = [value, node]
            @queue.enqueue(node)
          }
        end
      end

      def [](key)
        get(key)&.slice(0)
      end

      def []=(key, value)
        set(key, value)
      end

      private

      def remove_least_accesed
        item = @queue.dequeue()
        @hash.delete(item.value)
      end

      def update_access_table(node)
        @queue.move_back(node)
      end

    end


  end
end
