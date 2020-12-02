class Node
    attr_accessor :value, :left, :right, :parent
    def initialize(value=nil)
        @value = value
        @left = nil
        @right = nil
        @parent = nil
    end
end

class Tree
    attr_accessor :array, :root
    def initialize(array)
        @array = array.uniq.sort
        @root = nil
    end

    def build_tree(array=@array, start_array=0, end_array=@array.length-1)
        if start_array>end_array 
            return nil
        else
            mid = (start_array + end_array)/2
            node = Node.new(array[mid])
            node.left = build_tree(array, start_array, mid-1)
            node.right = build_tree(array, mid+1, end_array)
            node.left.parent = node if node.left != nil
            node.right.parent = node if node.right != nil 
        end
        @root = node
        return @root   
    end

    def find(value, node=@root)
        if node.value == value
            return node
        elsif node.left != nil && value < node.value
            find(value, node.left)
        elsif node.right != nil && value > node.value
            find(value, node.right)
        else
            return "The value doesn't exist"
        end
    end

    def insert(value, node=@root)
        if find(value).class != String
            return "The value is already on the tree"
        elsif node.value > value && node.left == nil
            node.left = Node.new(value)
            node.left.parent = node
            return node
        elsif node.value < value && node.right == nil
            node.right = Node.new(value)
            node.right.parent = node
            return node
        else
            if node.value > value
                insert(value, node.left)
            elsif node.value < value
                insert(value, node.right)
            end
        end
    end

    def delete(value)
        node = find(value)
        return node if node.class == String
        parent_node = node.parent
        if node.left == nil && node.right == nil
            parent_node.left == node ? parent_node.left = nil : parent_node.right = nil
        elsif node.left == nil && node.right != nil || node.left != nil && node.right == nil
            if node.left != nil
                child_node = node.left
                parent_node.left == node ? parent_node.left = child_node : parent_node.right = child_node
                child_node.parent = parent_node
            elsif node.right != nil
                child_node = node.right
                parent_node.left == node ? parent_node.left = child_node : parent_node.right = child_node
                child_node.parent = parent_node
            end
        elsif node.left != nil && node.right != nil 
            child_node = node.right
            while child_node.left != nil
                child_node = child_node.left
            end
            child_node_value = child_node.value
            child_node_parent = child_node.parent
            if child_node.right != nil
                new_child_node = child_node.right
                child_node_parent.left == child_node ? child_node_parent.left = new_child_node : child_node_parent.right = new_child_node
                new_child_node.parent = child_node_parent
            elsif child_node.right == nil
                child_node_parent.left ==child_node ? child_node_parent.left = nil : child_node_parent.right = nil
            end
            node.value = child_node_value
        end
        return @root
    end

    def level_order
        queue = [@root]
        level_order = []
        while queue.length > 0
            level_order.push(queue[0].value)
            queue.push(queue[0].left) if queue[0].left != nil
            queue.push(queue[0].right) if queue[0].right != nil
            queue.shift()
        end
        return level_order
    end

    def inorder(node=@root)
        if node.left != nil
            inorder(node.left)
            p node.value
        elsif node.left == nil 
            p node.value
        end
        if node.right != nil
            inorder(node.right)
        end
    end

    def preorder(node=@root)
        p node.value
        if node.left != nil 
            preorder(node.left)
        end
        if node.right != nil
            preorder(node.right)
        end
    end

    def postorder(node=@root)
        if node.left != nil
            postorder(node.left)
        end
        if node.right != nil 
            postorder(node.right)
        end
        p node.value
    end

    def depth(value)
        node = find(value)
        return node if node.class == String
        depth = 0
        while node.parent != nil
            depth += 1
            node = node.parent
        end
        return "The value's depth is #{depth}"
    end

    def height(value)
        node = find(value)
        return node if node.class == String
        height = find_height(node)
        return "The value's height is #{height}"
    end

    def find_height(node, current_height=0)
        return current_height if node.left.nil? && node.right.nil?
        current_height += 1
        if node.left != nil && node.right != nil
        [find_height(node.left, current_height), find_height(node.right, current_height)].max
        elsif node.left == nil
            find_height(node.right, current_height)
        elsif node.right == nil
            find_height(node.left, current_height)
        end
    end

    def balanced?
        if find_height(@root.left) - find_height(@root.right) == 0 || find_height(@root.left) - find_height(@root.right) == 1
            return true
        elsif find_height(@root.right) - find_height(@root.left) == 0 || find_height(@root.right) - find_height(@root.left) == 1
            return true
        else
            return false
        end
    end

    def rebalance
        array = level_order.sort
        build_tree(array)
    end

end


testing = Tree.new([1, 7, 8, 4, 6, 6, 3, 8, 9, 2, 5, 7])
p testing.build_tree
p testing.balanced?
p testing.find(7)
p testing.find(32)
p testing.insert(1)
p testing.insert(32)
p testing.insert(35)
p testing.level_order
p testing.inorder
p testing.preorder
p testing.postorder
p testing.height(5)
p testing.height(32)
p testing.depth(5)
p testing.depth(32)
p testing.balanced?
p testing.rebalance
p testing.balanced?
p testing.delete(5)
p testing.find(5)
