import tkinter as tk
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
from heated_plate import heated_plate_mod

class TwoDSteadyStateThermalSolverGUI:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Distribuição Térmica 2D em Regime Permanente")

        self.current_T = None
        self.colorbar = None
        self.motion_cid = None

        self._setup_ui()
        self._setup_plot()

    def _setup_ui(self):
        """Create input fields and controls"""
        tk.Label(self.root, text="Pontos em X:").grid(row=0, column=0)
        self.m_entry = tk.Entry(self.root)
        self.m_entry.insert(0, "200")
        self.m_entry.grid(row=0, column=1)

        tk.Label(self.root, text="Pontos em Y:").grid(row=1, column=0)
        self.n_entry = tk.Entry(self.root)
        self.n_entry.insert(0, "200")
        self.n_entry.grid(row=1, column=1)

        tk.Label(self.root, text="Topo:").grid(row=2, column=0)
        self.top_entry = tk.Entry(self.root)
        self.top_entry.insert(0, "100.0")
        self.top_entry.grid(row=2, column=1)

        tk.Label(self.root, text="Base:").grid(row=3, column=0)
        self.bottom_entry = tk.Entry(self.root)
        self.bottom_entry.insert(0, "0.0")
        self.bottom_entry.grid(row=3, column=1)

        tk.Label(self.root, text="Esquerda:").grid(row=4, column=0)
        self.left_entry = tk.Entry(self.root)
        self.left_entry.insert(0, "75.0")
        self.left_entry.grid(row=4, column=1)

        tk.Label(self.root, text="Direita:").grid(row=5, column=0)
        self.right_entry = tk.Entry(self.root)
        self.right_entry.insert(0, "50.0")
        self.right_entry.grid(row=5, column=1)

        tk.Button(self.root, text="Calcular", command=self.plot).grid(row=6, columnspan=2)

    def _setup_plot(self):
        """Create matplotlib figure and canvas"""
        self.fig = Figure(figsize=(6, 5))
        self.ax = self.fig.add_subplot(111)
        self.ax.set_xlabel('X (Normalizado)')
        self.ax.set_ylabel('Y (Normalizado)')

        self.canvas = FigureCanvasTkAgg(self.fig, master=self.root)
        self.canvas.get_tk_widget().grid(row=0, column=2, rowspan=7, padx=10)

    def _get_parameters(self):
        """Extract parameters from input fields"""
        return {
            'm': int(self.m_entry.get()),
            'n': int(self.n_entry.get()),
            'top': float(self.top_entry.get()),
            'bottom': float(self.bottom_entry.get()),
            'left': float(self.left_entry.get()),
            'right': float(self.right_entry.get()),
            'tol': 1e-4
        }

    def plot(self):
        """Calculate and display heat distribution"""
        try:
            params = self._get_parameters()
            self.current_T = heated_plate_mod.heated_plate_solver(**params)

            self.ax.clear()
            self.ax.set_xlabel('X (Normalizado)')
            self.ax.set_ylabel('Y (Normalizado)')

            # Create heatmap
            im = self.ax.imshow(self.current_T, cmap='hot', extent=[0, 1, 0, 1], origin='upper')

            # Create/update colorbar
            if self.colorbar is None:
                self.colorbar = self.fig.colorbar(im, ax=self.ax, label='Temperatura (°C)')
            else:
                self.colorbar.update_normal(im)

            # Setup mouse event (only once)
            if self.motion_cid is None:
                self.motion_cid = self.canvas.mpl_connect('motion_notify_event', self._on_mouse_move)

            self.canvas.draw()

        except Exception as e:
            tk.messagebox.showerror("Erro", f"Valores inválidos!\n{str(e)}")

    def _on_mouse_move(self, event):
        """Handle mouse movement over the plot"""
        if event.inaxes == self.ax and self.current_T is not None:
            x, y = event.xdata, event.ydata

            i = int((1 - y) * self.current_T.shape[0])  # Flip y coordinate because of origin='upper'
            j = int(x * self.current_T.shape[1])

            if 0 <= i < self.current_T.shape[0] and 0 <= j < self.current_T.shape[1]:
                self.ax.set_title(f'Temperatura: {self.current_T[i, j]:.2f}°C')
                self.canvas.draw()

    def run(self):
        """Start the GUI"""
        self.root.mainloop()


if __name__ == "__main__":
    app = TwoDSteadyStateThermalSolverGUI()
    app.run()

