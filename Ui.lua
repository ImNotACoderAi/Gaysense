local Services = {
	UserInputService = game:GetService("UserInputService"),
	TweenService = game:GetService("TweenService"),
	HttpService = game:GetService("HttpService"),
	RunService = game:GetService("RunService"),
	CoreGui = game:GetService("CoreGui")
}

local Variables = {
	Mouse = game:GetService("Players").LocalPlayer:GetMouse(),
	LocalPlayer = game:GetService("Players").LocalPlayer,
	ViewPort = workspace.CurrentCamera.ViewportSize,
	Players = game:GetService("Players"),
	Camera = workspace.CurrentCamera,
	DynamicSize = nil,
	DisableDragging = false
}

local Configuration = {
	Toggles = {},
	Sliders = {}
}

Utilities = {
	Settings = function(Defaults, Options)
		for i, v in pairs(Defaults) do
			Options[i] = Options[i] or v
		end
		return Options
	end,

	Tween = function(Object, Goal, Duration, Callback)
		local TweenType = Enum.EasingStyle.Cubic, Enum.EasingDirection.Out

		local Tween = Services.TweenService:Create(Object, TweenInfo.new(Duration, TweenType), Goal)
		Tween:Play()
		if Callback then
			Tween.Completed:Once(Callback)
		end
		return Tween
	end,

	Dragify = function(Frame)
		local Dragging, DragInput, MousePosition, FramePosition
		local UserInputService, Camera = Services.UserInputService, Variables.Camera

		local function _Update(Input)
			local delta = Input.Position - MousePosition
			local newPosition = UDim2.new(FramePosition.X.Scale, FramePosition.X.Offset + delta.X, FramePosition.Y.Scale, FramePosition.Y.Offset + delta.Y)
			Utilities.Tween(Frame, {Position = newPosition}, 0.2)
		end

		Frame.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not Variables.DisableDragging then
					Dragging = true
					MousePosition = Input.Position
					FramePosition = Frame.Position

					if UserInputService.TouchEnabled then
						UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
						UserInputService.ModalEnabled = true
						Camera.CameraType = Enum.CameraType.Scriptable
					end

					Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							Dragging = false
							if UserInputService.TouchEnabled then
								UserInputService.MouseBehavior = Enum.MouseBehavior.Default
								UserInputService.ModalEnabled = false
								Camera.CameraType = Enum.CameraType.Custom
							end
						end
					end)
				end
			end
		end)

		Frame.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				DragInput = Input
			end
		end)

		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging and not Variables.DisableDragging then
				_Update(Input)
			end
		end)
	end,

	NewObject = function(Object, Properties)
		local CreatedObject = Instance.new(Object)
		for Property, Setting in pairs(Properties) do
			CreatedObject[Property] = Setting
		end
		return CreatedObject
	end,

	CreateCursor = function(Frame, CursorId)
		if not Frame or not CursorId then
			warn("Invalid parameters. Please provide a valid frame and rbxassetid.")
			return
		end

		local Mouse = Variables.LocalPlayer:GetMouse()

		local Cursor = Utilities.NewObject("ImageLabel", {
			Name = "CustomCursor - " .. CursorId,
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundTransparency = 1,
			Image = "rbxassetid://" .. CursorId,
			Parent = Frame
		})


		local UserInputService, RunService = Services.UserInputService, Services.RunService

		RunService.RenderStepped:Connect(function()
			local MouseX, MouseY = Mouse.X, Mouse.Y
			local FramePosition, FrameSize = Frame.AbsolutePosition, Frame.AbsoluteSize

			if MouseX >= FramePosition.X and MouseX <= FramePosition.X + FrameSize.X and
				MouseY >= FramePosition.Y and MouseY <= FramePosition.Y + FrameSize.Y then
				Cursor.Position = UDim2.new(0, MouseX - FramePosition.X - 2, 0, MouseY - FramePosition.Y - 2)
				Cursor.Visible = true
				UserInputService.MouseIconEnabled = false
			else
				Cursor.Visible = false
				UserInputService.MouseIconEnabled = true
			end
		end)
	end
}

Gaysense = {
	Gaysense = Utilities.NewObject("ScreenGui", {
		Parent = Services.RunService:IsStudio() and Variables.LocalPlayer:WaitForChild("PlayerGui") or Services.CoreGui,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		Name = "Gaysense",
		ResetOnSpawn = false,
		DisplayOrder = 2147483647
	})
}

function Gaysense:CreateWindow()
	local Interface = {
		ActiveTab = nil
	}

	do
		Interface.Interface = Utilities.NewObject("Frame", {
			Parent = Gaysense.Gaysense,
			Name = "Interface",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(13, 15, 16),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 472, 0, 419),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		Interface.Navigation = Utilities.NewObject("Frame", {
			Parent = Interface.Interface,
			Name = "Navigation",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(18, 20, 21),
			Size = UDim2.new(0, 100, 1, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		Interface.Title = Utilities.NewObject("Frame", {
			Parent = Interface.Navigation,
			Name = "Title",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, 0, 0, 42),
			Position = UDim2.new(0, 0, 0, 3),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1
		})

		Interface.Text = Utilities.NewObject("TextLabel", {
			Parent = Interface.Title,
			Name = "Text",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 15,
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = "GaySense"
		})

		Interface.TextGradient = Utilities.NewObject("UIGradient", {
			Parent = Interface.Text,
			Name = "TextGradient",
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(197, 46, 61)),ColorSequenceKeypoint.new(0.427, Color3.fromRGB(197, 48, 63)),ColorSequenceKeypoint.new(0.431, Color3.fromRGB(254, 251, 251)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))}
		})

		Interface.TextPadding = Utilities.NewObject("UIPadding", {
			Parent = Interface.Text,
			Name = "TextPadding",
			PaddingBottom = UDim.new(0, 5)
		})

		Interface.Buttons = Utilities.NewObject("ScrollingFrame", {
			Parent = Interface.Navigation,
			Name = "Buttons",
			Active = true,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 69420, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, 0, 1, -42),
			ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
			Position = UDim2.new(0, 0, 0, 42),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarThickness = 0,
			BackgroundTransparency = 1
		})

		Interface.ButtonsLayout = Utilities.NewObject("UIListLayout", {
			Parent = Interface.Buttons,
			Name = "ButtonsLayout",
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		Interface.Rainbow = Utilities.NewObject("Frame", {
			Parent = Interface.Interface,
			Name = "Rainbow",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, 0, 0, 3),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		Interface.Main = Utilities.NewObject("Frame", {
			Parent = Interface.Interface,
			Name = "Main",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, -100, 1, -3),
			Position = UDim2.new(0, 100, 0, 3),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1
		})

		Interface.Top = Utilities.NewObject("Frame", {
			Parent = Interface.Main,
			Name = "Top",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, 0, 0, 31),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1
		})

		Interface.Seperation = Utilities.NewObject("Frame", {
			Parent = Interface.Top,
			Name = "Seperation",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(24, 26, 28),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		Interface.Tabs = Utilities.NewObject("Frame", {
			Parent = Interface.Main,
			Name = "Tabs",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, 0, 1, -33),
			Position = UDim2.new(0, 0, 0, 33),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1
		})
		
		do
			Interface.EspPreview = Utilities.NewObject("Frame", {
				Parent = Interface.Interface,
				Name = "EspPreview",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(13, 15, 16),
				Size = UDim2.new(0, 160, 0.5, 0),
				Position = UDim2.new(1, 5, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Visible = false
			})

			Interface.Rainbow2 = Utilities.NewObject("Frame", {
				Parent = Interface.EspPreview,
				Name = "Rainbow",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 0, 3),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Preview = Utilities.NewObject("ViewportFrame", {
				Parent = Interface.EspPreview,
				Name = "Preview",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Box = Utilities.NewObject("Frame", {
				Parent = Interface.Preview,
				Name = "Box",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 116, 0, 136),
				Position = UDim2.new(0.5, 0, 0.5, 1),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.Box,
				Name = "Frame",
				ZIndex = 65,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 0, 1),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.Frame,
				Name = "Frame",
				ZIndex = 64,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 2, 1, 2),
				Position = UDim2.new(0, -1, 0, -1),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.Box,
				Name = "Frame",
				ZIndex = 65,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.Frame,
				Name = "Frame",
				ZIndex = 64,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 2, 1, 2),
				Position = UDim2.new(0, -1, 0, -1),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.Box,
				Name = "Frame",
				ZIndex = 65,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(0, 1, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.Frame,
				Name = "Frame",
				ZIndex = 64,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 2, 1, 2),
				Position = UDim2.new(0, -1, 0, -1),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.Box,
				Name = "Frame",
				ZIndex = 65,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(0, 1, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.Frame,
				Name = "Frame",
				ZIndex = 64,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 2, 1, 2),
				Position = UDim2.new(0, -1, 0, -1),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.HealthBar = Utilities.NewObject("Frame", {
				Parent = Interface.Preview,
				Name = "HealthBar",
				ZIndex = 65,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(140, 255, 45),
				Size = UDim2.new(0, 1, 0, 68),
				Position = UDim2.new(0.5, -62, 1, -104),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Frame = Utilities.NewObject("Frame", {
				Parent = Interface.HealthBar,
				Name = "Frame",
				ZIndex = 64,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 2, 2, 2),
				Position = UDim2.new(0, -1, -1, -1),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.TextLabel = Utilities.NewObject("TextLabel", {
				Parent = Interface.HealthBar,
				Name = "TextLabel",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Right,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 9,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0, 30, 0, 12),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "100",
				Position = UDim2.new(0, -2, 0, 0)
			})

			Interface.Name = Utilities.NewObject("TextLabel", {
				Parent = Interface.Preview,
				Name = "Name",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 9,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 116, 0, 9),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Preview Esp",
				Position = UDim2.new(0.5, 0, 0.5, -76)
			})

			Interface.Distance = Utilities.NewObject("TextLabel", {
				Parent = Interface.Preview,
				Name = "Distance",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 9,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(181, 181, 181),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 116, 0, 9),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "[ 0 Studs ]",
				Position = UDim2.new(0.5, 0, 0.5, 78)
			})

			Interface.Gun = Utilities.NewObject("TextLabel", {
				Parent = Interface.Preview,
				Name = "Gun",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 71, 34),
				TextSize = 9,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(255, 71, 34),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 116, 0, 9),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Deagle",
				Position = UDim2.new(0.5, 0, 0.5, 90)
			})

			Interface.Rig = Utilities.NewObject("Model", {
				Name = "Rig",
				Parent = Interface.Preview,
				WorldPivot = CFrame.new(-0.3400000035762787, 0, -0.30000001192092896, 1, 0, 1.7484555314695172e-07, 0, 1, 0, -1.7484555314695172e-07, 0, 1)
			})

			Interface.LegRight = Utilities.NewObject("Model", {
				Name = "LegRight",
				WorldPivot = CFrame.new(-0.4900009334087372, -1.685499668121338, -6.300000190734863, -1, 0, -8.742277657347586e-08, 0, 1, 0, 8.742277657347586e-08, 0, -1),
				Parent = Interface.Rig
			})

			Interface.LeftFoot = Utilities.NewObject("Part", {
				Name = "LeftFoot",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(-0.49000099301338196, -2.4000003337860107, -6.300000190734863, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.LegRight
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071039",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.LeftFoot
			})

			Interface.LeftLowerLeg = Utilities.NewObject("Part", {
				Name = "LeftLowerLeg",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(-0.4900009334087372, -1.7509998083114624, -6.300000190734863, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.LegRight
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071049",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.LeftLowerLeg
			})

			Interface.LeftUpperLeg = Utilities.NewObject("Part", {
				Name = "LeftUpperLeg",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(-0.4900009334087372, -0.9709991812705994, -6.300000190734863, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.LegRight
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071065",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.LeftUpperLeg
			})

			Interface.ArmRight = Utilities.NewObject("Model", {
				Name = "ArmRight",
				WorldPivot = CFrame.new(-1.4900014400482178, 0.20950138568878174, -6.3000006675720215) * CFrame.Angles(0, math.rad(-180), 0), -- Add -180 degrees to the Y rotation
				Parent = Interface.Rig
			})

			Interface.LeftHand = Utilities.NewObject("Part", {
				Name = "LeftHand",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(-1.4900014400482178, -0.3999992609024048, -6.3000006675720215, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.ArmRight
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430070991",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.LeftHand
			})

			Interface.LeftLowerArm = Utilities.NewObject("Part", {
				Name = "LeftLowerArm",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(-1.4900014400482178, 0.22600138187408447, -6.3000006675720215, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.ArmRight
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071005",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.LeftLowerArm
			})

			Interface.LeftUpperArm = Utilities.NewObject("Part", {
				Name = "LeftUpperArm",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(-1.4900014400482178, 0.8190015554428101, -6.3000006675720215, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.ArmRight
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071044",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.LeftUpperArm
			})

			Interface.ArmLeft = Utilities.NewObject("Model", {
				Name = "ArmLeft",
				WorldPivot = CFrame.new(1.5099999904632568, 0.2095014452934265, -6.3000006675720215) * CFrame.Angles(0, math.rad(-180), 0), -- Add -180 degrees to the Y rotation
				Parent = Interface.Rig
			})

			Interface.RightHand = Utilities.NewObject("Part", {
				Name = "RightHand",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(1.5099999904632568, -0.3999992609024048, -6.3000006675720215, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent =Interface. ArmLeft
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430070997",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.RightHand
			})

			Interface.RightLowerArm = Utilities.NewObject("Part", {
				Name = "RightLowerArm",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(1.5099999904632568, 0.22600138187408447, -6.3000006675720215, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.ArmLeft
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071013",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.RightLowerArm
			})

			Interface.RightUpperArm = Utilities.NewObject("Part", {
				Name = "RightUpperArm",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(1.5099999904632568, 0.8190015554428101, -6.3000006675720215, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.ArmLeft
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071041",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.RightUpperArm
			})

			Interface.LegLeft = Utilities.NewObject("Model", {
				Name = "LegLeft",
				WorldPivot = CFrame.new(0.5099999904632568, -1.685499668121338, -6.300000190734863) * CFrame.Angles(0, math.rad(-180), 0), -- Add -180 degrees to the Y rotation
				Parent = Interface.Rig
			})

			Interface.RightLowerLeg = Utilities.NewObject("Part", {
				Name = "RightLowerLeg",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(0.5099999904632568, -1.7509998083114624, -6.300000190734863, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.LegLeft
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071105",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.RightLowerLeg
			})

			Interface.RightUpperLeg = Utilities.NewObject("Part", {
				Name = "RightUpperLeg",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(0.5099999904632568, -0.9709991812705994, -6.300000190734863, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.LegLeft
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071105",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.RightUpperLeg
			})

			Interface.RightFoot = Utilities.NewObject("Part", {
				Name = "RightFoot",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(0.5099999904632568, -2.4000003337860107, -6.300000190734863, -1.0000009536743164, 1.490118428648657e-08, -1.4702740713801177e-07, -1.490118251012973e-08, 1.0000009536743164, -1.490114875934978e-08, 2.781823127406824e-08, 1.490114787117136e-08, -1),
				Parent = Interface.LegLeft
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071082",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.RightFoot
			})

			Interface.HumanoidPart = Utilities.NewObject("Model", {
				Name = "HumanoidPart",
				WorldPivot = CFrame.new(0.009999999776482582, -0.3500000238418579, -6.300000190734863) * CFrame.Angles(0, math.rad(-180), 0), -- Add -180 degrees to the Y rotation
				Parent = Interface.Rig
			})

			Interface.LowerTorso = Utilities.NewObject("Part", {
				Name = "LowerTorso",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(0.009999999776482582, -0.3500000238418579, -6.300000190734863, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				Parent = Interface.HumanoidPart
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071109",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.LowerTorso
			})

			Interface.UpperTorso = Utilities.NewObject("Part", {
				Name = "UpperTorso",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(0.009999999776482582, 0.6499999761581421, -6.300000190734863, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				Parent = Interface.HumanoidPart
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430071038",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.UpperTorso
			})

			Interface.Head = Utilities.NewObject("Part", {
				Name = "Head",
				BottomSurface = Enum.SurfaceType.Smooth,
				TopSurface = Enum.SurfaceType.Smooth,
				Size = Vector3.new(4, 1, 2),
				CFrame = CFrame.new(0.009999999776482582, 1.949999988079071, -6.300000190734863, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				Parent = Interface.HumanoidPart
			})

			Utilities.NewObject("SpecialMesh", {
				MeshId = "rbxassetid://7430070993",
				MeshType = Enum.MeshType.FileMesh,
				Parent = Interface.Head
			})

			Interface.face = Utilities.NewObject("Decal", {
				Name = "face",
				Texture = "rbxasset://textures/face.png",
				Parent = Interface.Head,
				Face = "Back"
			})
		end
	end

	Interface.Logic = {
		Methods = {
			Color = function()
				local numSegments = 100
				if not Interface.RainbowSegments then
					Interface.RainbowSegments = {}
					for i = 1, numSegments do
						local segment = Utilities.NewObject("Frame", {
							Parent = Interface.Rainbow,
							BorderSizePixel = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							Size = UDim2.new(1 / numSegments, 0, 1, 0),
							Position = UDim2.new((i - 1) / numSegments, 0, 0, 0),
							BorderColor3 = Color3.fromRGB(0, 0, 0)
						})
						table.insert(Interface.RainbowSegments, segment)
					end

					for i = 1, numSegments do
						local segment = Utilities.NewObject("Frame", {
							Parent = Interface.Rainbow2,
							BorderSizePixel = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							Size = UDim2.new(1 / numSegments, 0, 1, 0),
							Position = UDim2.new((i - 1) / numSegments, 0, 0, 0),
							BorderColor3 = Color3.fromRGB(0, 0, 0)
						})
						table.insert(Interface.RainbowSegments, segment)
					end
				end
				local hueOffset = (os.clock() * 0.25) % 1
				for i, segment in ipairs(Interface.RainbowSegments) do
					local hue = (hueOffset + (i / numSegments)) % 1
					segment.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				end
			end,
			
			Toggle = function(Object, state)
				if state == nil then
					Object.Visible = not Object.Visible
				else
					Object.Visible = state
				end
			end
		},

		Setup = function()
			local lastUpdate = 0
			local updateInterval = 1/60

			Interface.Logic.DestroySegments = function()
				if Interface.RainbowSegments then
					for _, segment in ipairs(Interface.RainbowSegments) do
						segment:Destroy()
					end
					Interface.RainbowSegments = nil
				end
			end

			if Interface.RainbowConnection then
				Interface.RainbowConnection:Disconnect()
			end

			Interface.RainbowConnection = Services.RunService.RenderStepped:Connect(function()
				local currentTime = os.clock()
				if currentTime - lastUpdate >= updateInterval then
					lastUpdate = currentTime
					Interface.Logic.Methods.Color()
				end
			end)

			Utilities.Dragify(Interface.Interface)
		end
	}

	function Interface:CreateTab(Name, Callback)
		Callback = Callback or function() end
		
		local Tab = {
			Hover = false,
			Active = false,
			GroupIndex = 0
		}

		local index

		do
			Tab.TabButton = Utilities.NewObject("Frame", {
				Parent = Interface.Buttons,
				Name = "TabButton",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(24, 26, 28),
				Size = UDim2.new(1, 0, 0, 20),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Tab.Name = Utilities.NewObject("TextLabel", {
				Parent = Tab.TabButton,
				Name = "Name",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = Name or "Tab"
			})

			Tab.NamePadding = Utilities.NewObject("UIPadding", {
				Parent = Tab.Name,
				Name = "NamePadding",
				PaddingLeft = UDim.new(0, 27)
			})

			Tab.Activator = Utilities.NewObject("Frame", {
				Parent = Tab.TabButton,
				Name = "Activator",
				Visible = false,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(197, 46, 61),
				Size = UDim2.new(0, 2, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Tab.Image = Utilities.NewObject("ImageLabel", {
				Parent = Tab.TabButton,
				Name = "Image",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AnchorPoint = Vector2.new(0, 0.5),
				Image = "rbxassetid://79819059369806",
				Size = UDim2.new(0, 15, 0, 15),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 7, 0.5, 0)
			})

			Tab.Tab = Utilities.NewObject("ScrollingFrame", {
				Parent = Interface.Tabs,
				Name = "Tab",
				Visible = false,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, 0),
				CanvasSize = UDim2.new(0, 0, 69420, 0),
				ScrollBarThickness = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Tab.TabPadding = Utilities.NewObject("UIPadding", {
				Parent = Tab.Tab,
				Name = "TabPadding",
				PaddingTop = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 5)
			})
		end

		Tab.Logic = {
			Methods = {
				DeactivateTab = function(self)
					if Tab.Active then
						Tab.Active = false
						Tab.Image.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Tab.Activator.Visible = false
						Tab.Tab.Visible = false
					end
				end,

				ActivateTab = function(self)
					if not Tab.Active then
						if Interface.ActiveTab and Interface.ActiveTab.Logic and Interface.ActiveTab.Logic.Methods then
							Interface.ActiveTab.Logic.Methods.DeactivateTab()
						end

						Tab.Active = true
						Tab.Image.ImageColor3 = Color3.fromRGB(196, 45, 60)
						Tab.Activator.Visible = true
						Tab.Tab.Visible = true
						Interface.ActiveTab = Tab
					end
				end
			},

			Events = {
				MouseEnter = function()
					Tab.Hover = true
					if not Tab.Active then
						Tab.Image.ImageColor3 = Color3.fromRGB(196, 45, 60)
						Tab.Activator.Visible = true
					end
				end,

				MouseLeave = function()
					Tab.Hover = false
					if not Tab.Active then
						Tab.Image.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Tab.Activator.Visible = false
					end
				end,

				InputBegan = function(Input)
					if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Tab.Hover then
						Tab.Logic.Methods:ActivateTab()
						Callback()
					end
				end
			},

			Setup = function()
				Tab.TabButton.MouseEnter:Connect(Tab.Logic.Events.MouseEnter)
				Tab.TabButton.MouseLeave:Connect(Tab.Logic.Events.MouseLeave)
				Services.UserInputService.InputBegan:Connect(Tab.Logic.Events.InputBegan)

				if Interface.ActiveTab == nil then
					Tab.Logic.Methods:ActivateTab()
				end
			end
		}

		function Tab:CreateGroup(Name)
			local Group = {
				Width = 149,
				SpacingX = 0,
				SpacingY = 0,
				MaxColumns = 2
			}

			Tab.GroupIndex = (Tab.GroupIndex or 0) + 1

			local index = Tab.GroupIndex

			do
				Group.Group = Utilities.NewObject("Frame", {
					Parent = Tab.Tab,
					Name = "Group",
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(0, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1
				})

				Group.Name = Utilities.NewObject("TextLabel", {
					Parent = Group.Group,
					Name = "Name",
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 9,
					FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
					TextColor3 = Color3.fromRGB(82, 84, 86),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 20),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = Name or "Group"
				})

				Group.Items = Utilities.NewObject("Frame", {
					Parent = Group.Group,
					Name = "Items",
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					AnchorPoint = Vector2.new(0, 1),
					Size = UDim2.new(1, 0, 1, -25),
					Position = UDim2.new(0, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1
				})

				Group.ItemsLayout = Utilities.NewObject("UIListLayout", {
					Parent = Group.Items,
					Name = "ItemsLayout",
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			end

			Group.Logic = {
				Methods = {
					UpdatePosition = function()
						local column = (index - 1) % Group.MaxColumns
						local row = math.floor((index - 1) / Group.MaxColumns)

						local posX = Group.SpacingX + (Group.Width + Group.SpacingX) * column
						local posY = Group.SpacingY

						for i = 1, index - 1 do
							local prevGroupColumn = (i - 1) % Group.MaxColumns
							if prevGroupColumn == column then
								local prevGroup = Tab.Tab:FindFirstChild("Group" .. i)
								if prevGroup then
									posY = posY + prevGroup.Size.Y.Offset + Group.SpacingY
								end
							end
						end

						if index % 2 == 0 then
							Group.Group.Position = UDim2.new(0, Group.Group.Position.X.Offset + 35, 0, posY)
						else
							Group.Group.Position = UDim2.new(0, posX, 0, posY)
						end
						Group.Group.Name = "Group" .. index
					end,

					UpdateSize = function()
						local Height = 38

						for _, v in pairs(Group.Items:GetChildren()) do
							if v.Name == "Toggle" then
								Height = Height + 22
							elseif v.Name == "Slider" then
								Height = Height + 30
							elseif v.Name == "ColorPicker" then
								Height = Height + 15
							end
						end

						Group.Group.Size = UDim2.new(0, Group.Width, 0, Height)

						local thisColumn = (index - 1) % Group.MaxColumns

						local columnGroups = {}
						for i = 1, Group.MaxColumns do
							columnGroups[i] = {}
						end

						for i = 1, Tab.GroupIndex do
							local group = Tab.Tab:FindFirstChild("Group" .. i)
							if group then
								local groupColumn = ((i - 1) % Group.MaxColumns) + 1
								table.insert(columnGroups[groupColumn], {index = i, group = group})
							end
						end

						for column, groups in ipairs(columnGroups) do
							local currentY = Group.SpacingY
							for _, groupData in ipairs(groups) do
								local posX = Group.SpacingX + (Group.Width + Group.SpacingX) * (column - 1)
								
								if groupData.index % 2 == 0 then
									groupData.group.Position = UDim2.new(0, posX + 35, 0, currentY)
								else
									groupData.group.Position = UDim2.new(0, posX, 0, currentY)
								end
								
								currentY = currentY + groupData.group.Size.Y.Offset + Group.SpacingY
							end
						end
					end
				},

				Setup = function()
					Group.Logic.Methods.UpdatePosition()
					Group.Logic.Methods.UpdateSize()
					
					print(index, Name)
				end
			}

			function Group:AddToggle(Settings)
				Settings = Utilities.Settings({
					Name = "Toggle",
					Default = false,
					Callback = function(v)
						
					end
				}, Settings or {})

				local Toggle = {
					Hover = false,
					MouseDown = false,
					State = Settings.Default
				}

				do
					Toggle.Toggle = Utilities.NewObject("Frame", {
						Parent = Group.Items,
						Name = "Toggle",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.new(1, 0, 0, 13),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1
					})

					Toggle.Toggled = Utilities.NewObject("Frame", {
						Parent = Toggle.Toggle,
						Name = "Toggled",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(197, 46, 61),
						Size = UDim2.new(0, 13, 0, 13),
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					Toggle.ToggledCorner = Utilities.NewObject("UICorner", {
						Parent = Toggle.Toggled,
						Name = "ToggledCorner",
						CornerRadius = UDim.new(0, 3)
					})

					Toggle.Mark = Utilities.NewObject("ImageLabel", {
						Parent = Toggle.Toggled,
						Name = "Mark",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Image = "rbxassetid://123353417219461",
						Size = UDim2.new(1, 0, 1, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1
					})

					Toggle.Name = Utilities.NewObject("TextLabel", {
						Parent = Toggle.Toggle,
						Name = "Name",
						BorderSizePixel = 0,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -20, 1, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = Settings.Name,
						Position = UDim2.new(0, 20, 0, 0)
					})
				end

				Toggle.Logic = {
					Methods = {
						ToggleState = function(Bool, self)
							if Bool == nil then
								Toggle.State = not Toggle.State
							else
								Toggle.State = Bool
							end

							if Toggle.State then
								Toggle.Toggled.BackgroundColor3 = Color3.fromRGB(197, 46, 61)
								Toggle.Mark.ImageTransparency = 0
							else
								Toggle.Toggled.BackgroundColor3 = Color3.fromRGB(26, 28, 30)
								Toggle.Mark.ImageTransparency = 1
							end

							Settings.Callback(Toggle.State)	
						end,

						InitializeState = function(self)
							self:ToggleState(Settings.Default)
						end
					},

					Events = {
						MouseEnter = function()
							Toggle.Hover = true
						end,

						MouseLeave = function()
							Toggle.Hover = false
						end,

						InputBegan = function(Input)
							if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Toggle.Hover then
								Toggle.MouseDown = true
								Toggle.Logic.Methods.ToggleState()
							end
						end,

						InputEnded = function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
								Toggle.MouseDown = false
							end
						end
					},

					Setup = function()
						Toggle.Toggle.MouseEnter:Connect(Toggle.Logic.Events.MouseEnter)
						Toggle.Toggle.MouseLeave:Connect(Toggle.Logic.Events.MouseLeave)
						Services.UserInputService.InputBegan:Connect(Toggle.Logic.Events.InputBegan)
						Services.UserInputService.InputEnded:Connect(Toggle.Logic.Events.InputEnded)

						Toggle.Logic.Methods:InitializeState()

						Group.Logic.Methods.UpdateSize()
					end
				}		

				function Toggle:Set(State)
					Toggle.Logic.Methods.ToggleState(State)
				end

				Toggle.Logic.Setup()

				return Toggle
			end
			
			function Group:AddSlider(Settings)
				Settings = Utilities.Settings({
					Name = "Slider",
					Min = 0,
					Max = 20,
					Default = 5,
					Increment = 1,
					Callback = function(v)
						print(v)
					end
				}, Settings or {})
				
				local Slider = {
					MouseDown = false,
					Hover = false,
					Connection = nil
				}
				
				do
					Slider.Slider = Utilities.NewObject("Frame", {
						Parent = Group.Items,
						Name = "Slider",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.new(1, 0, 0, 18),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1
					})

					Slider.Name = Utilities.NewObject("TextLabel", {
						Parent = Slider.Slider,
						Name = "Name",
						BorderSizePixel = 0,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 13),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = Settings.Name
					})

					Slider.Value = Utilities.NewObject("TextLabel", {
						Parent = Slider.Slider,
						Name = "Value",
						BorderSizePixel = 0,
						TextXAlignment = Enum.TextXAlignment.Right,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 13),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = "1.000"
					})

					Slider.Background = Utilities.NewObject("Frame", {
						Parent = Slider.Slider,
						Name = "Background",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(27, 29, 31),
						AnchorPoint = Vector2.new(0, 1),
						Size = UDim2.new(1, 0, 0, 3),
						Position = UDim2.new(0, 0, 1, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					Slider.Fill = Utilities.NewObject("Frame", {
						Parent = Slider.Background,
						Name = "Fill",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(113, 115, 119),
						Size = UDim2.new(0, 70, 1, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					Slider.FillCorner = Utilities.NewObject("UICorner", {
						Parent = Slider.Fill,
						Name = "FillCorner",
						CornerRadius = UDim.new(0, 69420)
					})

					Slider.BackgroundCorner = Utilities.NewObject("UICorner", {
						Parent = Slider.Background,
						Name = "BackgroundCorner",

					})
				end
				
				Slider.Logic = {
					Methods = {
						GetValue = function(self)
							return tonumber(Slider.Value.Text)
						end,

						SetValue = function(self, v)
							if v == nil then
								local percentage = math.clamp((Variables.Mouse.X - Slider.Background.AbsolutePosition.X) / Slider.Background.AbsoluteSize.X, 0, 1)
								local value = ((Settings.Max - Settings.Min) * percentage) + Settings.Min
								value = math.round(value / Settings.Increment) * Settings.Increment

								Slider.Value.Text = string.format("%.1f", value)
								Utilities.Tween(Slider.Fill, {Size = UDim2.fromScale(percentage, 1)}, 0.3)
							else
								local clampedValue = math.clamp(v, Settings.Min, Settings.Max)
								clampedValue = math.round(clampedValue / Settings.Increment) * Settings.Increment
								local percentage = (clampedValue - Settings.Min) / (Settings.Max - Settings.Min)

								Slider.Value.Text = string.format("%.1f", clampedValue)
								Utilities.Tween(Slider.Fill, {Size = UDim2.fromScale(percentage, 1)}, 0.3)
							end

							Settings.Callback(Slider.Logic.Methods:GetValue())
						end,

						Initialize = function(self)
							self:SetValue(Settings.Default)
						end
					},

					Events = {
						MouseEnter = function()
							Slider.Hover = true
						end,

						MouseLeave = function()
							Slider.Hover = false
						end,

						InputBegan = function(Input)
							if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Slider.Hover then
								Variables.DisableDragging = true
								Slider.MouseDown = true

								if not Slider.Connection then
									Slider.Connection = Services.RunService.RenderStepped:Connect(function()
										Slider.Logic.Methods:SetValue()
									end)
								end
							end
						end,

						InputEnded = function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
								Variables.DisableDragging = false
								Slider.MouseDown = false

								if Slider.Connection then 
									Slider.Connection:Disconnect() 
								end
								Slider.Connection = nil
							end
						end
					},

					Setup = function()
						Slider.Slider.MouseEnter:Connect(Slider.Logic.Events.MouseEnter)
						Slider.Slider.MouseLeave:Connect(Slider.Logic.Events.MouseLeave)
						Services.UserInputService.InputBegan:Connect(Slider.Logic.Events.InputBegan)
						Services.UserInputService.InputEnded:Connect(Slider.Logic.Events.InputEnded)

						Slider.Logic.Methods:Initialize()

						Group.Logic.Methods.UpdateSize()
					end
				}

				Slider.Logic.Setup()

				function Slider:GetValue()
					Slider.Logic.Methods.GetValue()
				end

				function Slider:SetValue(value)
					Slider.Logic.Methods.SetValue(self, value)
				end
				
				return Slider
			end
			
			function Group:AddColorPicker(Settings)
				Settings = Utilities.Settings({
					Name = "ColorPicker",
					Default = Color3.fromRGB(255, 0, 0),
					Callback = function(v)
						print(v)
					end    
				}, Settings or {})
				
				local ColorPicker = {
					IsPickingColor = false,
					IsWindowOpen = false,

					CurrentColor = Settings.Default,
					CurrentValue = 1,

					Dragging = false,

					HoverStates = {
						IsHoveringColorWheel = false,
						IsHoveringDarknessSlider = false,
						IsHoveringPreview = false
					}
				}
				
				do
					ColorPicker.ColorPicker = Utilities.NewObject("Frame", {
						Parent = Group.Items,
						Name = "ColorPicker",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.new(1, 0, 0, 13),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1
					})

					ColorPicker.Name = Utilities.NewObject("TextLabel", {
						Parent = ColorPicker.ColorPicker,
						Name = "Name",
						BorderSizePixel = 0,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = Settings.Name
					})

					ColorPicker.Preview = Utilities.NewObject("Frame", {
						Parent = ColorPicker.ColorPicker,
						Name = "Preview",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						AnchorPoint = Vector2.new(1, 0.5),
						Size = UDim2.new(0, 11, 0, 11),
						Position = UDim2.new(1, 0, 0.5, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					ColorPicker.ToggledCorner = Utilities.NewObject("UICorner", {
						Parent = ColorPicker.Preview,
						Name = "ToggledCorner",
						CornerRadius = UDim.new(0, 3)
					})

					ColorPicker.Window = Utilities.NewObject("Frame", {
						Parent = ColorPicker.ColorPicker,
						Name = "Window",
						Visible = false,
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(13, 15, 16),
						Size = UDim2.new(0, 155, 0, 155),
						Position = UDim2.new(1, 0, 0.5, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					ColorPicker.WindowPadding = Utilities.NewObject("UIPadding", {
						Parent = ColorPicker.Window,
						Name = "WindowPadding",
						PaddingTop = UDim.new(0, 2),
						PaddingRight = UDim.new(0, 2),
						PaddingLeft = UDim.new(0, 2),
						PaddingBottom = UDim.new(0, 4)
					})

					ColorPicker.Spectrum = Utilities.NewObject("Frame", {
						Parent = ColorPicker.Window,
						Name = "Spectrum",
						Active = true,
						ZIndex = 35,
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.new(0, 20, 0, 125),
						Position = UDim2.new(0, 129, 0, 0),
						BorderColor3 = Color3.fromRGB(28, 43, 54)
					})

					ColorPicker.SpectrumGradient = Utilities.NewObject("UIGradient", {
						Parent = ColorPicker.Spectrum,
						Name = "SpectrumGradient",
						Rotation = 90,
						Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 0, 5)),ColorSequenceKeypoint.new(0.200, Color3.fromRGB(255, 255, 0)),ColorSequenceKeypoint.new(0.400, Color3.fromRGB(0, 255, 0)),ColorSequenceKeypoint.new(0.600, Color3.fromRGB(0, 255, 255)),ColorSequenceKeypoint.new(0.800, Color3.fromRGB(0, 0, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 0, 255))}
					})

					ColorPicker.SpectrumStroke = Utilities.NewObject("UIStroke", {
						Parent = ColorPicker.Spectrum,
						Name = "SpectrumStroke",
						Color = Color3.fromRGB(28, 43, 54)
					})

					ColorPicker.Square = Utilities.NewObject("Frame", {
						Parent = ColorPicker.Window,
						Name = "Square",
						ZIndex = 35,
						BackgroundColor3 = Color3.fromRGB(255, 0, 0),
						Size = UDim2.new(0, 125, 0, 125),
						BorderColor3 = Color3.fromRGB(28, 43, 54)
					})

					ColorPicker.Image = Utilities.NewObject("ImageLabel", {
						Parent = ColorPicker.Square,
						Name = "Image",
						ZIndex = 35,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Image = "rbxassetid://114999312790646",
						Size = UDim2.new(1, 0, 1, 0),
						BorderColor3 = Color3.fromRGB(28, 43, 54),
						BackgroundTransparency = 1
					})

					ColorPicker.Select = Utilities.NewObject("Frame", {
						Parent = ColorPicker.Image,
						Name = "Select",
						ZIndex = 35,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = UDim2.new(0.05, 0, 0.05, 0),
						BorderColor3 = Color3.fromRGB(28, 43, 54)
					})

					ColorPicker.UICorner = Utilities.NewObject("UICorner", {
						Parent = ColorPicker.Select,
						Name = "SelectCorner",
						CornerRadius = UDim.new(0.5, 0)
					})

					ColorPicker.UIStroke = Utilities.NewObject("UIStroke", {
						Parent = ColorPicker.Select,
						Name = "SelectStroke",
						Thickness = 2,
						Color = Color3.fromRGB(28, 30, 34)
					})

					ColorPicker.CustomColor = Utilities.NewObject("Frame", {
						Parent = ColorPicker.Window,
						Name = "CustomColor",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(30, 30, 34),
						Size = UDim2.new(0, 125, 0, 20),
						Position = UDim2.new(0, 0, 0, 130),
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					ColorPicker.Hex = Utilities.NewObject("TextBox", {
						Parent = ColorPicker.CustomColor,
						Name = "Hex",
						BorderSizePixel = 0,
						TextXAlignment = Enum.TextXAlignment.Left,
						PlaceholderText = "#FFFFFF",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 10,
						FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = "#FFFFFF"
					})

					ColorPicker.HexPadding = Utilities.NewObject("UIPadding", {
						Parent = ColorPicker.Hex,
						Name = "HexPadding",
						PaddingLeft = UDim.new(0, 5)
					})

					ColorPicker.WindowPreview = Utilities.NewObject("Frame", {
						Parent = ColorPicker.Window,
						Name = "WindowPreview",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						AnchorPoint = Vector2.new(1, 1),
						Size = UDim2.new(0, 20, 0, 20),
						Position = UDim2.new(1, -2, 1, 1),
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})
				end
				
				ColorPicker.Logic = {
					Methods = {
						setColor = function(color)
							ColorPicker.CurrentColor = color
							ColorPicker.Preview.BackgroundColor3 = color
							ColorPicker.Select.BackgroundColor3 = color
							ColorPicker.WindowPreview.BackgroundColor3 = color

							local h, s, v = color:ToHSV()

							ColorPicker.Square.BackgroundColor3 = Color3.fromHSV(h, 1, 1)

							local squareSize = ColorPicker.Square.AbsoluteSize
							if squareSize then
								local x = s * squareSize.X
								local y = (1 - v) * squareSize.Y
								ColorPicker.Select.Position = UDim2.new(0, x, 0, y)
							end

							local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
							local hexString = string.format("#%02X%02X%02X", r, g, b)
							ColorPicker.Hex.Text = hexString

							Settings.Callback(color)
						end,

						updateColorFromSpectrum = function(yPosition)
							local spectrumHeight = ColorPicker.Spectrum.AbsoluteSize.Y
							local relativeY = math.clamp(yPosition - ColorPicker.Spectrum.AbsolutePosition.y, 0, spectrumHeight)

							local hue = relativeY / spectrumHeight
							local _, saturation, value = ColorPicker.CurrentColor:ToHSV()
							local color = Color3.fromHSV(hue, saturation, value)

							ColorPicker.Logic.Methods.setColor(color)
						end,

						updateColorFromSquare = function(xPosition, yPosition)
							local squareSize = ColorPicker.Square.AbsoluteSize

							local relativeX = math.clamp(xPosition - ColorPicker.Square.AbsolutePosition.X, 0, squareSize.X)
							local relativeY = math.clamp(yPosition - ColorPicker.Square.AbsolutePosition.Y, 0, squareSize.Y)

							local saturation = relativeX / squareSize.X
							local value = 1 - (relativeY / squareSize.Y)
							local hue, _, _ = ColorPicker.CurrentColor:ToHSV()
							local color = Color3.fromHSV(hue, saturation, value)

							ColorPicker.Logic.Methods.setColor(color)
						end,

						updateColorFromHex = function(hexString)
							hexString = hexString:gsub("#", "")

							if hexString:match("^%x%x%x%x%x%x$") then
								local r = tonumber(hexString:sub(1, 2), 16)
								local g = tonumber(hexString:sub(3, 4), 16)
								local b = tonumber(hexString:sub(5, 6), 16)

								if r and g and b then
									local color = Color3.fromRGB(r, g, b)
									ColorPicker.Logic.Methods.setColor(color)
									return true
								end
							end
							return false
						end
					},

					Events = {
						SpectrumInputBegan = function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								ColorPicker.IsPickingColor = true
								ColorPicker.Logic.Methods.updateColorFromSpectrum(input.Position.Y)
							end
						end,

						SpectrumInputChanged = function(input)
							if ColorPicker.IsPickingColor and input.UserInputType == Enum.UserInputType.MouseMovement then
								ColorPicker.Logic.Methods.updateColorFromSpectrum(input.Position.Y)
								Variables.DisableDragging = true
							end
						end,

						SquareInputBegan = function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								ColorPicker.IsPickingColor = true
								ColorPicker.Logic.Methods.updateColorFromSquare(input.Position.X, input.Position.Y)
							end
						end,

						SquareInputChanged = function(input)
							if ColorPicker.IsPickingColor and input.UserInputType == Enum.UserInputType.MouseMovement then
								ColorPicker.Logic.Methods.updateColorFromSquare(input.Position.X, input.Position.Y)
								Variables.DisableDragging = true
							end
						end,

						InputEnded = function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								ColorPicker.IsPickingColor = false
								Variables.DisableDragging = false
							end
						end,

						PreviewMouseEnter = function()
							ColorPicker.HoverStates.IsHoveringPreview = true
						end,

						PreviewMouseLeave = function()
							ColorPicker.HoverStates.IsHoveringPreview = false
						end,

						PreviewInputBegan = function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and ColorPicker.HoverStates.IsHoveringPreview then
								if ColorPicker.IsWindowOpen then
									ColorPicker.Window.Visible = false
								else
									ColorPicker.Window.Visible = true
								end

								ColorPicker.IsWindowOpen = not ColorPicker.IsWindowOpen
							end
						end,
						
						HexChanged = function()
							local text = ColorPicker.Hex.Text
							if (#text == 7 and text:sub(1, 1) == "#") or (#text == 6 and text:sub(1, 1) ~= "#") then
								local success = ColorPicker.Logic.Methods.updateColorFromHex(text)
								if not success then
									local r, g, b = math.floor(ColorPicker.CurrentColor.R * 255), 
									math.floor(ColorPicker.CurrentColor.G * 255), 
									math.floor(ColorPicker.CurrentColor.B * 255)
									ColorPicker.Hex.Text = string.format("#%02X%02X%02X", r, g, b)
								end
							end
						end
					},

					Setup = function()
						ColorPicker.Spectrum.InputBegan:Connect(ColorPicker.Logic.Events.SpectrumInputBegan)
						ColorPicker.Spectrum.InputChanged:Connect(ColorPicker.Logic.Events.SpectrumInputChanged)
						Services.UserInputService.InputEnded:Connect(ColorPicker.Logic.Events.InputEnded)

						ColorPicker.Square.InputBegan:Connect(ColorPicker.Logic.Events.SquareInputBegan)
						ColorPicker.Square.InputChanged:Connect(ColorPicker.Logic.Events.SquareInputChanged)
						Services.UserInputService.InputEnded:Connect(ColorPicker.Logic.Events.InputEnded)

						ColorPicker.Preview.MouseEnter:Connect(ColorPicker.Logic.Events.PreviewMouseEnter)
						ColorPicker.Preview.MouseLeave:Connect(ColorPicker.Logic.Events.PreviewMouseLeave)

						ColorPicker.Preview.InputBegan:Connect(ColorPicker.Logic.Events.PreviewInputBegan)

						ColorPicker.Hex.Changed:Connect(ColorPicker.Logic.Events.HexChanged)

						local r, g, b = math.floor(ColorPicker.CurrentColor.R * 255), 
						math.floor(ColorPicker.CurrentColor.G * 255), 
						math.floor(ColorPicker.CurrentColor.B * 255)
						ColorPicker.Hex.Text = string.format("#%02X%02X%02X", r, g, b)
						
						ColorPicker.Logic.Methods.setColor(Settings.Default)

						Group.Logic.Methods.UpdateSize()
					end
				}

				function ColorPicker:SetColor(Color)
					ColorPicker.Logic.Methods.setColor(Color)
				end

				function ColorPicker:GetColor(Color)
					return ColorPicker.CurrentColor
				end
				
				ColorPicker.Logic.Setup()
				
				return ColorPicker
			end

			Group.Logic.Setup()

			return Group
		end

		Tab.Logic.Setup()

		return Tab
	end

	function Interface:CreateEspPreview()
		local Esp = {}
		
		function Esp:TogglePreview(state)
			Interface.Logic.Methods.Toggle(Interface.EspPreview, state)
		end
		
		function Esp:ToggleBox()
			Interface.Logic.Methods.Toggle(Interface.Box)
		end
		
		function Esp:ToggleHealthBar()
			Interface.Logic.Methods.Toggle(Interface.HealthBar)
		end
		
		function Esp:ToggleDistance()
			Interface.Logic.Methods.Toggle(Interface.Distance)
		end
		
		function Esp:ToggleGun()
			Interface.Logic.Methods.Toggle(Interface.Gun)
		end
		
		function Esp:ToggleName()
			Interface.Logic.Methods.Toggle(Interface.Name)
		end
		
		return Esp
	end

	Interface.Logic.Setup()

	return Interface
end

coroutine.wrap(function()
	local Chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+🤐🏻 🤑🏻 🤒🏻 🤓🏻 🤔🏻 🤕🏻 🤗🏻 ༼ ༽ ༕ ༖ ࿄ ࿅ ࿇ ࿈ ࿉ ࿊ ࿋ ࿌ ࿏ 𝌆 𝌇 𝌈 𝌉 𝌊 𝌋 𝌌 𝌍 𝌎 𝌏 𝌐 𝌑 𝌒 𝌓 𝌔 𝌕 𝌖 𝌗 𝌘 𝌙 𝌚 𝌛 𝌜 𝌝 𝌞 𝌟 𝌠 𝌡 𝌢 𝌣 𝌤 𝌥 𝌦 𝌧 𝌨 𝌩 𝌪 𝌫 𝌬 𝌭 𝌮 𝌯 𝌰 𝌱 𝌲 𝌳 𝌴 𝌵 𝌶 𝌷 𝌸 𝌹 𝌺 𝌻 𝌼 𝌽 𝌾 𝌿 𝍀 𝍁 𝍂 𝍃 𝍄 𝍅 𝍆 𝍇 𝍈 𝍉 𝍊 𝍋 𝍌 𝍍 𝍎 𝍏 𝍐 𝍑 𝍒 𝍓 𝍔 𝍕 𝍖😀 😃 😄 😁 😆 😅 😂 🤣 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 😘 😗 😙 😚 😋 😜 😝 😛 🤑 🤗 🤓 😎 🤡 🤠 😏 😒 😞 😔 😟 😕 🙁 ☹️ 😣 😖 😫 😩 😤 😠 😡 😶 😐 😑 😯 😦 😧 😮 😲 😵 😳 😱 😨 😰 😢 😥 🤤 😭 😓 😪 😴 🙄 🤔 🤥 😬 🤐 🤢 🤧 😷 🤒 🤕 😈 👿 👶 👦 👧 👨 👩 👱‍♀️ 👱 👴 👵 👲 👳‍♀️ 👳 👮‍♀️ 👮 👷‍♀️ 👷 💂‍♀️ 💂 🕵️‍♀️ 🕵️ 👩‍⚕️ 👨‍⚕️ 👩‍🌾 👨‍🌾 👩‍🍳 👨‍🍳 👩‍🎓 👨‍🎓 👩‍🎤 👨‍🎤 👩‍🏫 👨‍🏫 👩‍🏭 👨‍🏭 👩‍💻 👨‍💻 👩‍💼 👨‍💼 👩‍🔧 👨‍🔧 👩‍🔬 👨‍🔬 👩‍🎨 👨‍🎨 👩‍🚒 👨‍🚒 👩‍✈️ 👨‍✈️ 👩‍🚀 👨‍🚀 👩‍⚖️ 👨‍⚖️ 🤶 🎅 👸 🤴 👰 🤵 👼 🤰 🙇‍♀️ 🙇 💁 💁‍♂️ 🙅 🙅‍♂️ 🙆 🙆‍♂️ 🙋 🙋‍♂️ 🤦‍♀️ 🤦‍♂️ 🤷‍♀️ 🤷‍♂️ 🙎 🙎‍♂️ 🙍 🙍‍♂️ 💇 💇‍♂️ 💆 💆‍♂️ 🕴️‍♀️ 🕴 💃 🕺 👯 👯‍♂️ 🚶‍♀️ 🚶 🏃‍♀️ 🏃 ⛷ 🏂 🏋️‍♀️ 🏋️ 🤺 🤼‍♀️ 🤼‍♂️ 🤸‍♀️ 🤸‍♂️ ⛹️‍♀️ ⛹️ 🤾‍♀️ 🤾‍♂️ 🏌️‍♀️ 🏌️ 🏄‍♀️ 🏄 🏊‍♀️ 🏊 🤽‍♀️ 🤽‍♂️ 🚣‍♀️ 🚣 🏇 🚴‍♀️ 🚴 🚵‍♀️ 🚵 🤹‍♀️ 🤹‍♂️ 👳🏽 👳🏽 👳🏽‍♀️ 👮🏻 👮🏻‍♀️ 〠 シ ツ ㋡ ﺕ ☺ ☻ ☹ ッ ⌤ ⍢ ⍤ ⍥ ⍨ ⍩ ☃ ⚍ 𒐣 𒐤 𒐥 𒐦 𒐧 𒐨 𒐩 𒐪 𒐫 𒐬 𒐭 𒐮 𒐯 𒐰 𒐱 𒐲 𒐳 𒈙 𒀰 𒁏 𒅌 𒄡 𒊎 𒍙 𒈓 𒅃 𒌧 𒀱 𒁎 𒈟 𒌄 𒈙 ㎚ ㎛ ㎜ ㎝ ㎞ ㏌ ㎟ ㎠ ㎡ ㎢ ㎣ ㎤ ㎥ ㎦ ㎕ ㎖ ㎗ ㎘ ㏄ ㎰ ㎱ ㎲ ㎳ ㎍ ㎎ ㎏ ㎅ ㎆ ㎇ ㎐ ㎑ ㎒ ㎓ ㎔ ㎴ ㎵ ㎶ ㎷ ㎸ ㎹ ㎺ ㎻ ㎼ ㎽ ㎾ ㎿ ㏀ ㏁ ㎀ ㎁ ㎂ ㎃ ㎄ ㎧ ㎨ ㎭ ㎮ ㎯ ㎩ ㎪ ㎫ ㎬ ㎈ ㎉ ㍷ ㍸ ㍹ ㎙ ㍱ ㍲ ㍳ ㍴ ㍵ ㍶ ㍺ ㎊ ㎋ ㎌ ㏃ ㏅ ㏆ ㏇ ㏈ ㏉ ㏊ ㏋ ㏍ ㏎ ㏏ ㏐ ㏑ ㏒ ㏓ ㏔ ㏕ ㏖ ㏗ ㏚ ㏛ ㏜ ㏝ ㏞ ㏟ ㏿ ㏂ ㏘ ㏙ 🂠 🂡 🂢 🂣 🂤 🂥 🂦 🂧 🂨 🂩 🂪 🂫 🂬 🂭 🂮 🂱 🂲 🂳 🂴 🂵 🂶 🂷 🂸 🂹 🂺 🂻 🂼 🂽 🂾 🂿 🃁 🃂 🃃 🃄 🃅 🃆 🃇 🃈 🃉 🃊 🃋 🃌 🃍 🃎 🃏 🃑 🃒 🃓 🃔 🃕 🃖 🃗 🃘 🃙 🃚 🃛 🃜 🃝 🃞 🃟 🃠 🃡 🃢 🃣 🃤 🃥 🃦 🃧 🃨 🃩 🃪 🃫 🃬 🃭 🃮 �🀰 🀱 🀲 🀳 🀴 🀵 🀶 🀷 🀸 🀹 🀺 🀻 🀼 🀽 🀾 🀿 🁀 🁁 🁂 🁃 🁄 🁅 🁆 🁇 🁈 🁉 🁊 🁋 🁌 🁍 🁎 🁏 🁐 🁑 🁒 🁓 🁔 🁕 🁖 🁗 🁘 🁙 🁚 🁛 🁜 🁝 🁞 🁟 🁠 🁡 🁢 🁣 🁤 🁥 🁦 🁧 🁨 🁩 🁪 🁫 🁬 🁭 🁮 🁯 🁰 🁱 🁲 🁳 🁴 🁵 🁶 🁷 🁸 🁹 🁺 🁻 🁼 🁽 🁾 🁿 🂀 🂁 🂂 🂃 🂄 🂅 🂆 🂇 🂈 🂉 🂊 🂋 🂌 🂍 🂎 🂏 🂐 🂑 🂒 �🀀 🀁 🀂 🀃 🀄 🀅 🀆 🀇 🀈 🀉 🀊 🀋 🀌 🀍 🀎 🀏 🀐 🀑 🀒 🀓 🀔 🀕 🀖 🀗 🀘 🀙 🀚 🀛 🀜 🀝 🀞 🀟 🀠 🀡 🀢 🀣 🀤 🀥 🀦 🀧 🀨 🀩 🀪 �▀ ▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▉ ▊ ▋ ▌ ▍ ▎ ▏ ▐ ░ ▒ ▓ ▔ ▕ ▖ ▗ ▘ ▙ ▚ ▛ ▜ ▝ ▞ ▟ ■ □ ▢ ▣ ▤ ▥ ▦ ▧ ▨ ▩ ▪ ▫ ▬ ▭ ▮ ▯ ◘ ◙ ◚ ◛ ◧ ◨◩ ◪ ◫ ◰ ◱ ◲ ◳ ◻ ◼ ◾ ◽ ❏ ❐ ❑ ❒ ❘ ❙ ❚ ⟤ ⟥ ⧠ 〓 ⌑ 🞗 🞘 🞙 🞚 🞛 🞜 🞝 🞞 🞟 🞠 ⛋ ⛞ ⛣ ⛶ ⯀ ⯁ ⮽ ⬚ ⬛ ⬜ ⬝ ⬞ ⯐ ⯑  ￭  � 🙾 � 🞎 🞏 🞐 🞑 🞒 🞓 🞔 🞕 � ◙ ◚ ◛ ⏛ ⧄ ⧅ ⧆ ⧇ ⧈ ⧉ ⧮ ⧯ ⃞ ⃢  ⃣ 🔳 🔲 🞌 🞍 🞎 🞏 🞐 🞑 🞒 🞓 🞔 🞕 ◈ ⟐ ⿰ ⿱ ⿲ ⿳ ⿴ ⿵ ⿶ ⿷ ⿸ ⿹ ⿺ ⿻ "

	Services.RunService.RenderStepped:Connect(function()
		local newString = ""
		
		for i = 1, math.random(5, 25) do
			local randomIndex = math.random(1, #Chars)
			newString = newString .. Chars:sub(randomIndex, randomIndex)
		end
		
		Gaysense.Gaysense.Name = newString
		
		if Gaysense.Parent == Variables.LocalPlayer.PlayerGui then
			Gaysense.Parent = Services.CoreGui
		else
			Gaysense.Parent = Variables.LocalPlayer.PlayerGui
		end
	end)
end)()

if _G.PreviousGaySense then
	_G.PreviousGaySense:Destroy()
end

_G.PreviousGaySense = Gaysense.Gaysense

return Gaysense
