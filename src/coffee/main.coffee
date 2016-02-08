ReactDOM = require 'react-dom'
React = require 'react'
reqwest = require 'reqwest'
http = require 'http'

Task = React.createClass
    displayName: 'Task'

    getInitialState: ->
      return null

    handleClick: (e)->
      @props.data.completed = !@props.data.completed
      @props.onTaskUpdate @props.data

    handleChange: (e)->
      e.preventDefault()
      @setState completed: e.target.checked
      @props.onTaskUpdate
        id: @props.data.id
        name: @props.data.name
        completed: @state.completed
        dateAdded: @props.data.dateAdded
        datePlanned: @props.data.datePlanned
        dateCompleted: @props.data.dateCompleted
      return

    render: ->
      <li className={if @props.data.completed then 'complete' else 'incomplete'} >
        <input type="checkbox" checked={@props.data.completed} onChange={@handleChange} />{@props.data.name}</li>


NewTask = React.createClass
    displayName: 'New Task'

    handleChange: (e)->
      @setState name: e.target.value

    handleSubmit: (e)->
      task = @state.name.trim()
      return if !task
      @props.onTaskSubmit
        name: @state.name
      @setState name: ''
      return

    getInitialState: ->
      name: ''

    render: ->
      <form onSubmit={@handleSubmit}>
        <input
          type="text"
          placeholder="New Task"
          value={@state.name}
          onChange={@handleChange}
        />
        <input
          type="submit"
          value="add"
        />
      </form>


Tasks = React.createClass
    displayName: 'Tasks'

    loadTasksFromApi: ->
      reqwest
        url: 'http://172.28.128.3:5000/api/tasks'
        method: 'get'
        type: 'json'
        success: (resp)=>
          @setState data: resp
          return
      return

    submitNewTaskToApi: (task)->
      reqwest
        url: 'http://172.28.128.3:5000/api/tasks'
        method: 'post'
        type: 'json'
        contentType: 'application/json'
        data: JSON.stringify task
        success: (resp)=>
          @setState data: @state.data.concat resp
          return
      return

    updateTaskToApi: (task)->
      #console.log task.completed
      reqwest
        url: 'http://172.28.128.3:5000/api/tasks/' + task.id
        method: 'put'
        type: 'json'
        contentType: 'application/json'
        data: JSON.stringify task
        success: (resp)=>
          #console.log resp
          #@setState @state.data.concat resp
          return
      @loadTasksFromApi()
      return

    putTaskIntoEdit: (edit)->
      return !edit

    getInitialState: ->
      data: []

    componentDidMount: ->
      @loadTasksFromApi()
      #setInterval @loadTasksFromApi, @props.pollInterval
      return

    render: ->
      <div>
        <NewTask onTaskSubmit={@submitNewTaskToApi}/>
        <ul>
          {@state.data.map (data) =>
            <Task key={data.id} data={data} onTaskUpdate={@updateTaskToApi}/>
          }
        </ul>
      </div>


ReactDOM.render(
    <Tasks pollInterval={10000} />
    document.getElementById 'container'
)
