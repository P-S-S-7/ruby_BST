class Node
	attr_accessor :value

	def initialize(value)
		@value = value
	end
end

class BSTNode < Node
	attr_accessor :left, :right

	def initialize(value)
		super(value)
		@left = nil
		@right = nil
	end
end

class LLNode < Node
	attr_accessor :next

	def initialize(value)
		super(value)
		@next = nil
	end
end

def read_input
	STDIN.gets.chomp.split(' ').map(&:to_i)
end

class BinarySearchTree
	attr_accessor :root

	def initialize
		@root = nil
	end

	def add_element(value)
		new_node = BSTNode.new(value)

		if root.nil?
			@root = new_node
			return
		end

		current = @root

		loop do
			if value == current.value
				puts "Duplication of value #{value} found. Skipping insertion."
				return
			elsif value < current.value
				if current.left.nil?
					current.left = new_node
					break
				else
					current = current.left
				end
			else
				if current.right.nil?
					current.right = new_node
					break
				else
					current = current.right
				end
			end
		end
	end

	def find_min(node = @root)
		return [] if node.nil?
		current = node
		current = current.left while current.left
		current.value
	end

	def find_max(node = @root)
		return [] if node.nil?
		current = node
		current = current.right while current.right
		current.value
	end

	def inorder_bst(node = @root, result = [])
		return result if node.nil?
		inorder_bst(node.left, result)
		result << node.value
		inorder_bst(node.right, result)
		result
	end

	def preorder_bst(node = @root, result = [])
		return result if node.nil?
		result << node.value
		preorder_bst(node.left, result)
		preorder_bst(node.right, result)
		result
	end

	def postorder_bst(node = @root, result = [])
		return result if node.nil?
		postorder_bst(node.left, result)
		postorder_bst(node.right, result)
		result << node.value
		result
	end

	def level_order_bst
		return [] if @root.nil?

		queue = Queue.new
		queue.push(@root)
		result = []
		until queue.empty?
			current = queue.pop
			result << current.value
			queue.push(current.left) unless current.left.nil?
			queue.push(current.right) unless current.right.nil?
		end
		result
	end

	def search(value, node = @root)
		return false if node.nil?

		return true if value == node.value
		return search(value, node.left) if value < node.value

		search(value, node.right)
	end

	def remove(value, node = @root)
		return nil if node.nil?

		if value < node.value
			node.left = remove(value, node.left)
		elsif value > node.value
			node.right = remove(value, node.right)
		else
			return node.right if node.left.nil?
			return node.left if node.right.nil?

			min_val = find_min(node.right)
			node.value = min_val
			node.right = remove(min_val, node.right)
		end

		@root = node if node == @root && value == @root.value

		node
	end

	def print_paths(node = @root, path = [], result = [])
		return result if node.nil?

		path << node.value
		if node.left.nil? && node.right.nil?
			result << path.clone
		else
			print_paths(node.left, path, result)
			print_paths(node.right, path, result)
		end
		path.pop

		result
	end
end

class LinkedList
	attr_accessor :head

	def initialize
		@head = nil
	end

	def add_element(value)
		new_node = LLNode.new(value)
		if @head.nil?
			@head = new_node
		else
			current = @head
			current = current.next while current.next
			current.next = new_node
		end
	end

	def delete_element(value)
		return if @head.nil?

		if @head.value == value
			@head = @head.next
			return
		end

		current = @head
		while current.next && current.next.value != value
			current = current.next
		end

		current.next = current.next.next if current.next
	end

	def search(value)
		current = @head
		while current
			return true if current.value == value
			current = current.next
		end
		false
	end

	def reverse
		prev = nil
		current = @head
		while current
			nxt = current.next
			current.next = prev
			prev = current
			current = nxt
		end
		@head = prev
	end

	def print_list
		result = []
		current = @head
		while current
			result << current.value
			current = current.next
		end
		result
	end
end

def input_method
	puts "Do you want to input data from a file? (y/n)"
	input_choice = STDIN.gets.chomp.downcase

	if input_choice == 'y'
		print "Enter file path: "
		file_path = STDIN.gets.chomp
		load_from_file(file_path)
	else
		puts "Starting with an empty #{@current_ds}."
	end
end

class ApplicationProgram
	def initialize
		@file_path = nil
		@current_ds = nil
	end

	def add_elements(elements)
		if @current_ds == "BST"
			elements.each { |el| @bst.add_element(el) }
		else
			elements.each { |el| @ll.add_element(el) }
		end
	end

	def load_from_file(file_path)
		@file_path = file_path
		if File.exist?(file_path)
			elements = File.read(file_path).chomp.split(' ').map(&:to_i)
			add_elements(elements)
			puts "#{@current_ds} formed from file input."
		else
			puts "File not found. Starting with an empty #{@current_ds}."
		end
	end

	def bst_menu
		input_method

		loop do
			puts "\nMenu:"
			puts "1. Add elements into the tree (multiple elements space-separated)"
			puts "2. Print the largest element"
			puts "3. Print the smallest element"
			puts "4. Print traversals (inorder, preorder, postorder, level order)"
			puts "5. Search an element"
			puts "6. Remove an element"
			puts "7. Print all the paths i.e., from root to leaf"
			puts "8. Quit"
			print "Enter your choice: "
			choice = STDIN.gets.chomp.to_i

			case choice
			when 1
				print "Enter elements (space-separated): "
				elements = read_input
				add_elements(elements)
				puts "Elements added."
			when 2
				puts "Largest element: #{@bst.find_max}"
			when 3
				puts "Smallest element: #{@bst.find_min}"
			when 4
				puts "Inorder: #{@bst.inorder_bst}"
				puts "Preorder: #{@bst.preorder_bst}"
				puts "Postorder: #{@bst.postorder_bst}"
				puts "Level order: #{@bst.level_order_bst}"
			when 5
				print "Enter element to search: "
				element = STDIN.gets.chomp.to_i
				puts @bst.search(element) ? "Element found." : "Element not found."
			when 6
				print "Enter element to remove: "
				element = STDIN.gets.chomp.to_i
				@bst.remove(element)
				puts "Element removed (if existed)."
			when 7
				paths = @bst.print_paths
				puts "Paths from root to leaves: #{paths.map { |path| path.join(' -> ') }}"
			when 8
				if @file_path
        	File.write(@file_path, @bst.inorder_bst.join(' '))
					puts "#{@current_ds} saved to file #{@file_path}."
				end
				break
			else
				puts "Invalid choice. Please try again."
			end
		end
	end

	def ll_menu
		input_method

		loop do
			puts "\nLinked List Menu:"
			puts "1. Add element"
			puts "2. Delete element"
			puts "3. Search for an element"
			puts "4. Reverse list"
			puts "5. Print list"
			puts "6. Back to main menu"
			print "Enter your choice: "
			choice = STDIN. gets.chomp.to_i

			case choice
			when 1
				print "Enter element to add: "
				element = STDIN.gets.chomp.to_i
				@ll.add_element(element)
				puts "Element added."
			when 2
				print "Enter element to delete: "
				element = STDIN.gets.chomp.to_i
				@ll.delete_element(element)
				puts "Element deleted (if it existed)."
			when 3
				print "Enter element to search: "
				element = STDIN.gets.chomp.to_i
				puts @ll.search(element) ? "Element found." : "Element not found."
			when 4
				@ll.reverse
				puts "List reversed."
			when 5
				puts "List: #{@ll.print_list.join(' -> ')}"
			when 6
				if @file_path
          File.write(@file_path, @ll.print_list.join(' '))
          puts "#{@current_ds} saved to file #{@file_path}."
				end
				break
			else
				puts "Invalid choice. Please try again."
			end
		end
	end

	def run
		loop do
			puts "\nMain Menu:"
			puts "1. Manage Binary Search Tree"
			puts "2. Manage Linked List"
			puts "3. Quit"
			print "Enter your choice: "
			choice = STDIN.gets.chomp.to_i

			case choice
			when 1
				@bst = BinarySearchTree.new
				@current_ds = "BST"
				bst_menu
			when 2
				@ll = LinkedList.new
				@current_ds = "LL"
				ll_menu
			when 3
				puts "Exiting application. Goodbye!"
				break
			else
				puts "Invalid choice. Please try again."
			end
		end
	end

	app = ApplicationProgram.new
	app.run
end
