% Definir el estado inicial y el estado objetivo
initial_state([0, 1, 3, 4, 2, 5, 7, 8, 6]). % Estado inicial del rompecabezas (0 representa el espacio en blanco)
goal_state([1, 2, 3, 4, 5, 6, 7, 8, 0]).   % Estado objetivo del rompecabezas

% Definir movimientos válidos según la posición del espacio en blanco
move(State, NewState) :-                  % Regla para generar un nuevo estado (NewState) a partir de un estado actual (State)
    nth0(BlankPos, State, 0),             % Encuentra la posición del espacio en blanco (0) en el estado actual
    neighbor(BlankPos, SwapPos),          % Encuentra una posición vecina válida para intercambiar
    swap(State, BlankPos, SwapPos, NewState). % Realiza el intercambio entre las posiciones para generar el nuevo estado

% Definir vecinos (movimientos válidos)
neighbor(0, 1). neighbor(0, 3).           % Vecinos de la posición 0 (puede moverse a las posiciones 1 o 3)
neighbor(1, 0). neighbor(1, 2). neighbor(1, 4). % Vecinos de la posición 1
neighbor(2, 1). neighbor(2, 5).           % Vecinos de la posición 2
neighbor(3, 0). neighbor(3, 4). neighbor(3, 6). % Vecinos de la posición 3
neighbor(4, 1). neighbor(4, 3). neighbor(4, 5). neighbor(4, 7). % Vecinos de la posición 4
neighbor(5, 2). neighbor(5, 4). neighbor(5, 8). % Vecinos de la posición 5
neighbor(6, 3). neighbor(6, 7).           % Vecinos de la posición 6
neighbor(7, 4). neighbor(7, 6). neighbor(7, 8). % Vecinos de la posición 7
neighbor(8, 5). neighbor(8, 7).           % Vecinos de la posición 8

% Intercambiar dos posiciones en una lista
swap(State, Pos1, Pos2, NewState) :-      % Regla para intercambiar dos posiciones en una lista
    nth0(Pos1, State, Elem1),             % Obtiene el elemento en la posición Pos1
    nth0(Pos2, State, Elem2),             % Obtiene el elemento en la posición Pos2
    set_element(Pos1, Elem2, State, TempState), % Reemplaza el elemento en Pos1 con Elem2
    set_element(Pos2, Elem1, TempState, NewState). % Reemplaza el elemento en Pos2 con Elem1, generando el nuevo estado

% Actualizar un elemento en una lista
set_element(Index, Elem, List, NewList) :- % Regla para reemplazar un elemento en una posición específica de una lista
    nth0(Index, List, _, Rest),            % Obtiene la lista sin el elemento en la posición Index
    nth0(Index, NewList, Elem, Rest).      % Inserta el nuevo elemento en la posición Index

% Algoritmo BFS para resolver el rompecabezas
bfs([[State, Path] | _], Path) :-          % Caso base: si el primer estado en la cola es el estado objetivo, retorna el camino
    goal_state(State).                     % Verifica si el estado actual coincide con el estado objetivo
bfs([[State, Path] | Rest], Solution) :-   % Caso recursivo: sigue explorando estados
    findall([NextState, [Move | Path]],    % Genera todos los estados vecinos válidos
            (move(State, NextState),       % Realiza un movimiento válido
             \+ member(NextState, Path),   % Asegura que el estado no haya sido visitado
             Move = NextState),            % Asocia el movimiento con el nuevo estado
            NextStates),                   % Lista de nuevos estados generados
    append(Rest, NextStates, NewQueue),    % Agrega los nuevos estados a la cola de búsqueda
    bfs(NewQueue, Solution).               % Continúa la búsqueda con la cola actualizada

% Resolver el rompecabezas
solve_8_puzzle :-                          % Regla principal para resolver el rompecabezas
    initial_state(InitialState),           % Obtiene el estado inicial
    bfs([[InitialState, []]], Solution),   % Ejecuta BFS para encontrar la solución
    reverse(Solution, Moves),              % Invierte el camino para mostrar los pasos en orden
    write('Movimientos para resolver el rompecabezas:'), nl, % Imprime un mensaje
    write_moves_3x3(Moves).                % Imprime los movimientos en formato 3x3

% Mostrar movimientos en formato 3x3
write_moves_3x3([]).                       % Caso base: no hay más movimientos por mostrar
write_moves_3x3([Move | Rest]) :-          % Caso recursivo: imprime el movimiento actual y pasa al siguiente
    print_3x3(Move), nl,                   % Imprime el estado en formato 3x3
    write_moves_3x3(Rest).                 % Continúa con los movimientos restantes

% Imprimir un estado en formato 3x3
print_3x3(State) :-                        % Regla para imprimir un estado en formato de matriz 3x3
    nth0(0, State, A), nth0(1, State, B), nth0(2, State, C), % Obtiene los elementos de la primera fila
    nth0(3, State, D), nth0(4, State, E), nth0(5, State, F), % Obtiene los elementos de la segunda fila
    nth0(6, State, G), nth0(7, State, H), nth0(8, State, I), % Obtiene los elementos de la tercera fila
    format('~w ~w ~w~n', [A, B, C]),      % Imprime la primera fila
    format('~w ~w ~w~n', [D, E, F]),      % Imprime la segunda fila
    format('~w ~w ~w~n', [G, H, I]).      % Imprime la tercera fila
