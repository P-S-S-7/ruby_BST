class Node
	attr_accessor :value, :left, :right

	def initialize(value)
		@value = value
		@left = nil
		@right = nil
	end
end

class BinarySearchTree
	attr_accessor :root

	def initialize
		@root = nil
	end

	def add_element(node, value)
		new_node = Node.new(value)

		if root.nil?
			@root = new_node
			return
		end

		current = @root

		loop do
			if value == current.value
				puts "Duplicate of value #{value} found. Skipping insertion"
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

	# Add multiple elements to the tree
	def add_elements(elements)
		elements.each { |el| add_element(@root, el) }
	end

	def find_min(node = @root)
		return nil if node.nil?
		return node.value if node.left.nil?

		find_min(node.left)
	end

	def find_max(node = @root)
		return nil if node.nil?
		return node.value if node.right.nil?

		find_max(node.right)
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

		queue = [@root]
		result = []
		until queue.empty?
			current = queue.shift
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

class Operations
	def initialize
		@bst = BinarySearchTree.new
		@file_path = nil
	end

	def load_from_file(file_path)
		@file_path = file_path
		if File.exist?(file_path)
			elements = File.read(file_path).split(',').map(&:to_i)
			@bst.add_elements(elements)
			puts "BST formed from file input..."
		else
			puts "File not found. Starting with an empty BST."
		end
	end

	def save_to_file
		return unless @file_path

		File.write(@file_path, @bst.inorder_bst.join(', '))
	end

	def run
		loop do
			puts "\nMenu:"
			puts "1. Add elements into the tree (multiple elements comma separated)"
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
				print "Enter elements (comma-separated): "
				elements = STDIN.gets.chomp.split(',').map(&:to_i)
				@bst.add_elements(elements)
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
				save_to_file
				puts "Tree saved to file..." unless @file_path.nil?
				puts "Exiting..."
				break
			else
				puts "Invalid choice. Please try again."
			end
		end
	end
end

if __FILE__ == $PROGRAM_NAME
	app = Operations.new
	if ARGV.length == 1
		app.load_from_file(ARGV[0])
	else
		puts "No file specified. Starting with an empty BST."
	end
	app.run
end

