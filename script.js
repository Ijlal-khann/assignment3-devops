// Simple Task Manager JavaScript

document.addEventListener('DOMContentLoaded', function() {
    const taskForm = document.getElementById('taskForm');
    const taskInput = document.getElementById('taskInput');
    const taskList = document.getElementById('taskList');
    const taskCounter = document.getElementById('taskCounter');
    const clearAllBtn = document.getElementById('clearAllBtn');
    const messageDiv = document.getElementById('message');
    const addTaskBtn = document.getElementById('addTaskBtn');

    let taskCount = 2; // Starting with 2 sample tasks

    // Add task functionality
    taskForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const taskName = taskInput.value.trim();
        
        if (taskName === '') {
            showMessage('Please enter a task name!', 'error');
            return;
        }

        addTask(taskName);
        taskInput.value = '';
        showMessage('Task added successfully!', 'success');
    });

    // Clear all tasks
    clearAllBtn.addEventListener('click', function() {
        if (confirm('Are you sure you want to clear all tasks?')) {
            taskList.innerHTML = '';
            taskCount = 0;
            updateCounter();
            showMessage('All tasks cleared!', 'success');
        }
    });

    function addTask(taskName) {
        const li = document.createElement('li');
        li.className = 'task-item';
        li.textContent = taskName;
        taskList.appendChild(li);
        
        taskCount++;
        updateCounter();
    }

    function updateCounter() {
        taskCounter.textContent = taskCount;
    }

    function showMessage(text, type) {
        messageDiv.textContent = text;
        messageDiv.className = 'message ' + type;
        
        setTimeout(() => {
            messageDiv.className = 'message';
        }, 3000);
    }

    // Log page load (for testing)
    console.log('Task Manager loaded successfully');
    console.log('Page load time:', performance.now().toFixed(2) + 'ms');
});

