ReactDOM = require 'react-dom'
React = require 'react'
reqwest = require 'reqwest'
moment = require 'moment'

TaskEditInline = React.createClass

    getInitialState: ->
      return (value: '')

    handleChange: (e)->
      @setState value: e.target.value
      return

    handleUpdate: (e)->
      @props.updateTask
        name: @state.value
      return

    handleInit: (e)->
      @setState value: @props.originalValue
      return

    render: ->
      <input
        className="input-task-edit"
        type="text"
        value={@state.value}
        onChange={@handleChange}
        onBlurCapture={@handleUpdate}
        onFocusCapture={@handleInit}
        ref={(ref)->
          if ref != null
            ref.focus()
          return
        }
      />

Task = React.createClass
    displayName: 'Task'

    getInitialState: ->
      return edit: false,
      taskProps: false

    handleClick: (e)->
      @props.onTaskUpdate @props.data

    handleComplete: (e)->
      today = new Date()
      @props.onTaskUpdate
        id: @props.data.id
        completed: e.target.checked
        dateCompleted: moment().format('YYYY-MM-DD')
      return

    handleChange: (task)->
      if task.name != @props.data.name
        @props.onTaskUpdate
          id: @props.data.id
          name: task.name
      @setState edit: false
      return

    handleDelete: (e)->
      e.preventDefault()
      @props.onTaskDelete
        id: @props.data.id
      return

    putTaskIntoEdit: (e)->
      e.preventDefault()
      @setState edit: true

    showTaskProperties: (e)->
      e.preventDefault()
      @setState taskProps: true

    hideTaskProperties: (e)->
      e.preventDefault()
      @setState taskProps: false

    render: ->
      <div>
        <div className="task row row-center" >
          <div className="task-checkbox column column-10">
            <input type="checkbox" checked={@props.data.completed} onChange={@handleComplete} />
          </div>
          <div className="column">
            {if !@state.edit
              <input type="text" onClickCapture={@putTaskIntoEdit}
                className={if @props.data.completed then 'complete task input-task-label' else 'incomplete task input-task-label'}
                value={@props.data.name}
              />
            else
              <TaskEditInline
                originalValue={@props.data.name}
                updateTask={@handleChange}
              />
            }
          </div>
          <div className="column column-20 task-delete-button">
            <div className="">
              {if @state.taskProps
                <button
                  onClickCapture={@hideTaskProperties}
                  className="button button-clear button-icon">
                  <i className="fa fa-chevron-circle-up "></i>
                </button>
              else
                <button
                  onClickCapture={@showTaskProperties}
                  className="button button-clear button-icon">
                  <i className="fa fa-chevron-circle-down"></i>
                </button>
              }
            </div>
          </div>
        </div>
        {if @state.taskProps
          <div className="task row row-center">
            hello
          </div>
        }
      </div>


NewTask = React.createClass
    displayName: 'New Task'

    handleChange: (e)->
      @setState name: e.target.value

    handleSubmit: (e)->
      e.preventDefault()
      task = @state.name.trim()
      return if !task
      @props.onTaskSubmit
        name: @state.name
      @setState name: ''
      return

    getInitialState: ->
      name: ''

    render: ->
      <div className="new-task">
        <div className="row">
          <div className="column datearea">
            {moment().format('dddd, DD MMMM YYYY')}
          </div>
        </div>
        <form onSubmit={@handleSubmit}>
          <div className="row row-center">
            <div className="column column-offset-10">
              <input
                className="input-task-edit"
                type="text"
                placeholder="New Task"
                value={@state.name}
                onChange={@handleChange}
              />
            </div>
            <div className="column column-20">
              <input
                className={if @state.name == '' then 'disabled'}
                type="submit"
                value="add"
              />
            </div>
          </div>
        </form>
      </div>


Tasks = React.createClass
    displayName: 'Tasks'

    loadTasksFromApi: ->
      reqwest
        url: 'http://localhost:5000/api/tasks/today'
        method: 'get'
        type: 'json'
        success: (resp)=>
          @setState data: resp
          return
      return

    submitNewTaskToApi: (task)->
      reqwest
        url: 'http://localhost:5000/api/tasks'
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
        url: 'http://localhost:5000/api/tasks/' + task.id
        method: 'put'
        type: 'json'
        contentType: 'application/json'
        data: JSON.stringify task
        success: (resp)=>
          #console.log resp
          #@setState @state.data.concat resp
          @loadTasksFromApi()
          return
      return

    deleteTaskFromApi: (task)->
      reqwest
        url: 'http://localhost:5000/api/tasks/' + task.id
        method: 'delete'
        type: 'json'
        contentType: 'application/json'
        success: (resp)=>
          #console.log resp
          #@setState @state.data.concat resp
          @loadTasksFromApi()
          return
      return

    getInitialState: ->
      data: []

    componentDidMount: ->
      @loadTasksFromApi()
      #setInterval @loadTasksFromApi, @props.pollInterval
      return

    render: ->
      <div className="container">
        <NewTask onTaskSubmit={@submitNewTaskToApi}/>
        <form className="">
          {@state.data.map (data) =>
            <Task key={data.id} data={data}
              onTaskUpdate={@updateTaskToApi}
              onTaskDelete={@deleteTaskFromApi}
            />
          }
        </form>
      </div>


ReactDOM.render(
    <Tasks pollInterval={10000} />
    document.getElementById 'container'
)
