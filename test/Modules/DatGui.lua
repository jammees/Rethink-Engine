--[[
   Roblox-dat.GUI v1.2.4 [2021-08-10 02:02]

   A lightweight graphical user interface and controller library. 
   
   Roblox dat.GUI allows you to easily manipulate variables and fire functions on 
   the fly, inspired by the venerable dat-gui.

   dat.GUI magically generates a graphical user interface (sliders, 
   color selector, etc) for each of your variables.

   This is a minified version of Roblox-dat.GUI, to see the full source code visit
   https://github.com/nidorx/roblox-dat-gui

   Discussions about this script are at https://devforum.roblox.com/t/817209

   ------------------------------------------------------------------------------

   MIT License

   Copyright (c) 2021 Alex Rodin

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
]]
do
	local a = math.huge
	local b = math.max
	local c = math.min
	local d = math.abs
	local e = Vector3.new
	local f = Vector2.new
	local g = Color3
	local h = UDim2.new
	local i = Enum
	local j = TweenInfo.new
	local k = Instance.new
	local l = table
	local m = tonumber
	local n = string
	local o = n.len
	local p = ipairs
	local q = false
	local r = true
	local s = nil
	local t = {
		e = "function",
		l = "(..)(..)(..)",
		m = "(.)(..)(..)(..)",
		n = "(.)(.)(.)",
		o = "(.)(.)(.)(.)",
		p = "number",
		q = "Number is expected for interval/delay",
		r = "LocalPlayer",
		s = "PlayerGui",
		t = "ScreenGui",
		u = "dat.GUI",
		v = "dat.GUI.Modal",
		w = "GUI_INSET",
		x = "SCREEN_GUI",
		y = "MODAL_GUI",
		z = "BACKGROUND_COLOR",
		A = "BACKGROUND_COLOR_HOVER",
		B = "SCROLLBAR_COLOR",
		C = "BORDER_COLOR",
		D = "BORDER_COLOR_2",
		E = "LABEL_COLOR",
		F = "LABEL_COLOR_DISABLED",
		G = "CLOSE_COLOR",
		H = "FOLDER_COLOR",
		I = "BOOLEAN_COLOR",
		J = "CHECKBOX_COLOR_ON",
		K = "CHECKBOX_COLOR_OFF",
		L = "CHECKBOX_COLOR_HOVER",
		M = "CHECKBOX_COLOR_IMAGE",
		N = "STRING_COLOR",
		O = "NUMBER_COLOR",
		P = "NUMBER_COLOR_HOVER",
		Q = "FUNCTION_COLOR",
		R = "INPUT_COLOR",
		S = "INPUT_COLOR_HOVER",
		T = "INPUT_COLOR_FOCUS",
		U = "INPUT_COLOR_FOCUS_TXT",
		V = "INPUT_COLOR_PLACEHOLDER",
		W = "CUSTOM_COLOR",
		X = "ICON_CHEVRON",
		Y = "rbxassetid://6690562401",
		Z = "ICON_CLOSE",
		aa = "rbxassetid://6690641420",
		ab = "ICON_CHECKMARK",
		ac = "rbxassetid://6690588631",
		ad = "ICON_RESIZE",
		ae = "rbxassetid://6690641141",
		af = "ICON_DRAG",
		ag = "rbxassetid://6690641345",
		ah = "ICON_RESIZE_SE",
		ai = "rbxassetid://6700720657",
		aj = "ICON_PIN",
		ak = "rbxassetid://6690641252",
		al = "CURSOR_RESIZE_SE",
		am = "rbxassetid://6700682562",
		ap = "OnEnter",
		aq = "OnHover",
		ar = "OnDown",
		as = "OnUp",
		at = "OnClick",
		au = "OnMove",
		aA = "GuiEventsMouseMovement",
		aB = "GuiEventsMouseButton1",
		aC = "GuiEventsTouch",
		aD = "drag",
		aE = "start",
		aI = "dat.Gui.OnScroll_",
		aK = "ImageLabel",
		aL = "Icon",
		aM = "Frame",
		aN = "TextLabel",
		aO = "LabelText",
		aQ = "BoolValue",
		aR = "Readonly",
		aS = "LabelVisible",
		aT = "StringValue",
		aU = "Label",
		aV = "BorderBottom",
		aW = "BorderLeft",
		aX = "Control",
		aY = "Value",
		aZ = "TextFrame",
		ba = "TextBox",
		bc = "TextBoxFake",
		bd = "BindableEvent",
		be = "NumberValue",
		bh = "Percent",
		bi = "Slider",
		bj = "SliderFG",
		bm = "Popover#",
		bp = "_reference",
		bq = "_position",
		br = "_offset",
		bt = "bottom",
		bv = "left",
		bw = "right",
		bx = "Chevron",
		bA = "Scrollbar",
		bB = "Thumb",
		bC = "ContentPosition",
		bD = "ContentHeight",
		bE = "IntValue",
		bF = "ParentHeight",
		bG = "Size",
		bH = "_parent",
		bI = "_content",
		bJ = "_parentHeight",
		bK = "_contentHeight",
		bL = "_contentPosition",
		bM = "_contentOffset",
		bO = "Panel",
		bP = "Content",
		bQ = "Header",
		bR = "Closed",
		bT = "_detached",
		bU = "_atached",
		bV = "_onDestroy",
		bW = "_actions",
		bX = "IsPanel",
		bY = "PanelId",
		bZ = "IsClosed",
		ca = "LayoutOrderOnPanel_",
		cb = "Action",
		cc = "Title",
		ce = "frame",
		cf = "remove",
		cg = "Detach",
		ch = "rbxassetid://6704730899",
		ci = "Shadow",
		cj = "ResizeHandleSE",
		ck = "Close",
		cl = "Atach",
		cp = "center",
		cs = "Name",
		ct = "ColorController",
		cu = "Color",
		cv = "Color3Value",
		cx = "Luminance",
		cy = "Saturation",
		cz = "#000000",
		cA = "#%.2X%.2X%.2X",
		cB = "Active",
		cC = "ChangeColors",
		cD = "Selector",
		cF = "SaturationContainer",
		cG = "UIGradient",
		cH = "Knob",
		cI = "SatLum",
		cJ = "rbxassetid://5787992121",
		cK = "Brightness",
		cL = "rbxassetid://5787998939",
		cN = "Position",
		cP = "height",
		cS = "OptionController",
		cT = "Selected",
		cU = "Options",
		cV = "Select",
		cW = "List",
		cX = "UIListLayout",
		cY = "Layout",
		cZ = "Item",
		da = "Option",
		db = "OptionIndex",
		dc = "item_",
		dd = "table",
		de = "Argument is not a table! It is: ",
		dg = "EnumItem",
		dh = "Enum",
		di = "string",
		dl = "StringController",
		dm = "Height",
		dn = "TextContainer",
		_do = "MultiLine",
		dr = "BooleanController",
		ds = "Checkbox",
		dt = "Check",
		dx = "NumberController",
		dy = "ValueIn",
		dB = "Step",
		dC = "Precision",
		dD = "Render",
		dE = "Parse",
		dL = "FunctionController",
		dN = "NumberSliderController",
		dS = "Vector3Controller",
		dT = "Vector3Value",
		ec = "Vector3SliderController",
		eg = "slider-container",
		eh = "TextValue",
		ei = "SliderValue",
		ej = "SliderMin",
		ek = "SliderMax",
		el = "RenderText",
		em = "Disconnect",
		eq = "Controllers",
		er = "Inner",
		es = "Text",
		et = "LineThrough",
		ev = "_name",
		ew = "isGui",
		ex = "parent",
		ey = "children",
		eA = "Object has no property ",
		eB = "Instance",
		eC = "Vector3",
		eD = "Color3",
		eE = "boolean",
		eF = "It was not possible to identify the controller builder, check the parameters",
		eG = "Logo",
		eN = "NUMBER_STEP",
		eO = "NUMBER_PRECISION",
		eQ = "disconnectFn",
		eR = "clear",
		eS = "countDecimals",
		eU = "createTextNumberFn",
		eV = "format",
		eW = "mapRange",
		eX = "fromRGB",
		eY = "bestContrast",
		eZ = "round",
		fa = "color3FromString",
		fb = "Heartbeat",
		fc = "IsRunning",
		fd = "Elapsed",
		fe = "Interval",
		ff = "IsTimeout",
		fg = "insert",
		fi = "SafeExec",
		fk = "unpack",
		fm = "clock",
		fn = "SetInterval",
		fo = "SetTimeout",
		fp = "Clear",
		fq = "IgnoreGuiInset",
		fr = "ZIndexBehavior",
		fs = "Sibling",
		ft = "DisplayOrder",
		fu = "Parent",
		fv = "LastMouseDown",
		fw = "UserInputState",
		fx = "Begin",
		fy = "Change",
		fz = "ContextActionResult",
		fC = "UserInputType",
		fD = "MouseMovement",
		fF = "MouseButton1",
		fG = "Touch",
		fH = "onEnter",
		fI = "onHover",
		fJ = "onDown",
		fL = "onClick",
		fM = "onMove",
		fN = "onDrag",
		fO = "onScroll",
		fP = "MouseWheel",
		fQ = "createImageLabel",
		fR = "AnchorPoint",
		fS = "BackgroundTransparency",
		fT = "BorderSizePixel",
		fU = "Selectable",
		fV = "SizeConstraint",
		fW = "RelativeXY",
		fX = "Visible",
		fY = "ZIndex",
		fZ = "Archivable",
		ga = "Image",
		gb = "ImageColor3",
		gc = "ImageTransparency",
		gd = "ScaleType",
		ge = "Stretch",
		gf = "SliceScale",
		gg = "createFrame",
		gh = "BackgroundColor3",
		gi = "BorderMode",
		gj = "Outline",
		gk = "Draggable",
		gl = "Style",
		gm = "FrameStyle",
		gn = "Custom",
		go = "createTextLabel",
		gp = "AutomaticSize",
		gs = "SourceSans",
		gt = "LineHeight",
		gu = "RichText",
		gv = "TextColor3",
		gw = "TextScaled",
		gx = "TextSize",
		gy = "TextStrokeTransparency",
		gz = "TextTransparency",
		gA = "TextTruncate",
		gB = "AtEnd",
		gC = "TextWrapped",
		gD = "TextXAlignment",
		gF = "TextYAlignment",
		gG = "Center",
		gH = "createControllerWrapper",
		gI = "Changed",
		gJ = "createInput",
		gK = "ClearTextOnFocus",
		gL = "CursorPosition",
		gM = "SelectionStart",
		gN = "ShowNativeInput",
		gO = "TextEditable",
		gQ = "Focused",
		gR = "FocusLost",
		gS = "Event",
		gT = "createSlider",
		gW = "AbsolutePosition",
		gX = "AbsoluteSize",
		gY = "clamp",
		gZ = "__index",
		ha = "_chevron",
		hb = "Rotation",
		hc = "EasingStyle",
		hd = "Quint",
		he = "EasingDirection",
		hg = "_disconnect",
		hh = "_cancelOnScroll",
		hi = "_tween",
		hj = "Offset",
		hk = "MIN_WIDTH",
		hl = "ClipsDescendants",
		hm = "LayoutOrder",
		hn = "ChildAdded",
		ho = "ChildRemoved",
		hr = "color",
		hs = "colorHover",
		ht = "title",
		hu = "BorderColor3",
		hv = "TextBounds",
		hw = "_disconnectDetach",
		hx = "_detachAction",
		hy = "_disconnectAtach",
		hz = "_hasDetachIcon",
		hA = "_detachedFrom",
		hB = "_closeAction",
		hC = "_atachAction",
		hD = "_scrollbar",
		hE = "_openSize",
		hF = "_size",
		hG = "_updateContentSizeTimeout",
		hI = "Width",
		hJ = "Enabled",
		hK = "Transparency",
		hL = "floor",
		hM = "fromHSV",
		hN = "getValue",
		hO = "onChange",
		hP = "setValue",
		hQ = "_is_removing_parent",
		hR = "removeChild",
		hS = "listen",
		hT = "FillDirection",
		hU = "Vertical",
		hV = "HorizontalAlignment",
		hW = "SortOrder",
		hX = "VerticalAlignment",
		hY = "EnumType",
		hZ = "options",
		ia = "methods",
		ib = "onRemove",
		ig = "label",
		ii = "readonly",
		ij = "width",
		ik = "closeable",
		il = "fixed",
		_in = "addCustom",
		io = "addLogo",
		iq = "addFolder",
		is = "_is_removing_child",
		iu = "close",
		iv = "resize",
		ix = "action",
		iy = "closed",
	}
	local u = game:GetService("ReplicatedStorage")
	local v = game:GetService("Players")
	local w = game:GetService("RunService")
	local x = game:GetService("UserInputService")
	local y = game:GetService("ContextActionService")
	local z = game:GetService("GuiService")
	local A = game:GetService("TweenService")
	local B = game:GetService("HttpService")
	local C = {}
	local D = {}
	local E = function(F)
		if not C[F] then
			C[F] = { r = D[F]() }
		end
		return C[F].r
	end
	D[2] = function()
		local G = {}
		G[t.eN] = 0.01
		G[t.eO] = 2
		G.AXES = { "X", "Y", "Z" }
		G[t.eQ] = function(H, ...)
			local I = { ... }
			return function()
				for J, K in p(I) do
					if type(K) == t.e then
						K()
					else
						K:Disconnect()
					end
				end
				for J, K in p(H) do
					if type(K) == t.e then
						K()
					else
						K:Disconnect()
					end
				end
				l[t.eR](H)
			end
		end
		G[t.eS] = function(L)
			local M = tostring(L)
			local N, J = n.find(M, ".", 1, r)
			if N ~= s then
				return o(M) - (N - 1) - 1
			end
			return 0
		end
		G[t.eU] = function(O)
			return function(P)
				if P == s then
					P = ""
				end
				if o(P) == 0 then
					P = ""
				else
					P = m(P)
					if P == s then
						P = ""
					else
						P = n[t.eV]("%." .. O[t.aY] .. "f", P)
					end
				end
				return P
			end
		end
		G[t.eW] = function(L, Q, R, S, T)
			return S + (L - Q) * (T - S) / (R - Q)
		end
		local U = g[t.eX](0, 0, 0)
		local V = g[t.eX](255, 255, 255)
		G[t.eY] = function(W)
			local X = math[t.eZ]((W.R * 255 * 299 + W.G * 255 * 587 + W.B * 255 * 114) / 1000)
			if X > 125 then
				return U
			else
				return V
			end
		end
		G[t.fa] = function(Y)
			local Z, _, a0, a1
			if o(Y) == 6 then
				Z, _, a0 = Y:match(t.l)
			elseif o(Y) == 7 then
				a1, Z, _, a0 = Y:match(t.m)
			elseif o(Y) == 3 then
				Z, _, a0 = Y:match(t.n)
				Z = Z .. Z
				_ = _ .. _
				a0 = a0 .. a0
			elseif o(Y) == 4 then
				a1, Z, _, a0 = Y:match(t.o)
				Z = Z .. Z
				_ = _ .. _
				a0 = a0 .. a0
			else
				return s
			end
			Z, _, a0 = m(Z, 16), m(_, 16), m(a0, 16)
			return g[t.eX](Z, _, a0)
		end
		return G
	end
	D[3] = function()
		local a2 = w
		local a3 = 1
		local a4 = {}
		local a5 = 30
		local a6 = 9007199254740991
		a2[t.fb]:Connect(function(a7)
			local a8 = {}
			local a9 = 0
			for aa, ab in p(a4) do
				if not ab[t.fc] then
					ab[t.fd] = ab[t.fd] + a7 * 1000
					if ab[t.fd] >= ab[t.fe] then
						ab[t.fd] = ab[t.fd] - ab[t.fe]
						if ab[t.ff] then
							l[t.fg](a8, ab)
						end
						coroutine.wrap(ab[t.fi])()
						a9 = a9 + 1
						if a9 > a5 then
							break
						end
					end
				end
			end
			for J, ab in p(a8) do
				local ac = l.find(a4, ab)
				if ac ~= s then
					l[t.cf](a4, ac)
				end
			end
		end)
		local function ad(ae, af, ag, ah)
			local ai = a3
			a3 = a3 + 1
			if af == s or af < 0 then
				af = 0
			end
			if type(af) ~= t.p then
				error(t.q)
			end
			af = c(a6, af)
			local ab = {}
			ab.Id = ai
			ab[t.fi] = function()
				ab[t.fc] = r
				local aj, ak = pcall(ae, l[t.fk](ah))
				ab[t.fc] = q
				ab[t.fd] = 0
				if not aj then
					warn(ak)
				end
			end
			ab[t.ff] = ag
			ab[t.fd] = 0
			ab.Init = os[t.fm]()
			ab[t.fe] = af
			l[t.fg](a4, ab)
			return ai
		end
		local al = {}
		al[t.fn] = function(ae, af, ...)
			return ad(ae, af, q, { ... })
		end
		al[t.fo] = function(ae, af, ...)
			return ad(ae, af, r, { ... })
		end
		al[t.fp] = function(ai)
			for ac, ab in p(a4) do
				if ab.Id == ai then
					l[t.cf](a4, ac)
					break
				end
			end
		end
		return al
	end
	D[6] = function()
		local am = v
		local an = am[t.r] or am:GetPropertyChangedSignal(t.r):Wait()
		local ao = an:WaitForChild(t.s)
		local ap = k(t.t)
		ap.Name = t.u
		ap[t.fq] = r
		ap[t.fr] = i[t.fr][t.fs]
		ap[t.ft] = 6
		ap[t.fu] = ao
		local aq = k(t.t)
		aq.Name = t.v
		aq[t.fq] = r
		aq[t.fr] = i[t.fr][t.fs]
		aq[t.ft] = 7
		aq[t.fu] = ao
		local ar = 36
		return {
			[t.w] = ar,
			[t.x] = ap,
			[t.y] = aq,
			[t.z] = g[t.eX](26, 26, 26),
			[t.A] = g[t.eX](17, 17, 17),
			[t.B] = g[t.eX](103, 103, 103),
			[t.C] = g[t.eX](44, 44, 44),
			[t.D] = g[t.eX](85, 85, 85),
			[t.E] = g[t.eX](238, 238, 238),
			[t.F] = g[t.eX](136, 136, 136),
			[t.G] = g[t.eX](234, 53, 51),
			[t.H] = g[t.eX](0, 0, 0),
			[t.I] = g[t.eX](128, 103, 135),
			[t.J] = g[t.eX](47, 161, 214),
			[t.K] = g[t.eX](60, 60, 60),
			[t.L] = g[t.eX](48, 48, 48),
			[t.M] = g[t.eX](255, 255, 255),
			[t.N] = g[t.eX](30, 211, 111),
			[t.O] = g[t.eX](47, 161, 214),
			[t.P] = g[t.eX](68, 171, 218),
			[t.Q] = g[t.eX](230, 29, 95),
			[t.R] = g[t.eX](48, 48, 48),
			[t.S] = g[t.eX](60, 60, 60),
			[t.T] = g[t.eX](73, 73, 73),
			[t.U] = g[t.eX](255, 255, 255),
			[t.V] = g[t.eX](117, 117, 117),
			[t.W] = g[t.eX](160, 32, 240),
			[t.X] = t.Y,
			[t.Z] = t.aa,
			[t.ab] = t.ac,
			[t.ad] = t.ae,
			[t.af] = t.ag,
			[t.ah] = t.ai,
			[t.aj] = t.ak,
			[t.al] = t.am,
		}
	end
	D[7] = function()
		local a2 = w
		local as = x
		local at = y
		local am = v
		local an = am[t.r] or am:GetPropertyChangedSignal(t.r):Wait()
		local ao = an:WaitForChild(t.s)
		local au = z
		local av, J = au:GetGuiInset()
		local al = E(3)
		local aw = {}
		local ax = { ["*"] = { [t.ap] = {}, [t.aq] = {}, [t.ar] = {}, [t.as] = {}, [t.at] = {}, [t.au] = {} } }
		local ay = s
		local az = {}
		local aA = {}
		local aB = s
		local aC = q
		local aD = 0
		local function aE(aF, aG, aH)
			if aF == s then
				aF = "*"
			end
			local aI = ax[aF]
			if aI == s then
				aI = { [t.ap] = {}, [t.aq] = {}, [t.ar] = {}, [t.as] = {}, [t.at] = {}, [t.au] = {} }
				ax[aF] = aI
			end
			l[t.fg](aI[aG], aH)
			return function()
				local aJ = l.find(aI[aG], aH)
				if aJ ~= s then
					l[t.cf](aI[aG], aJ)
				end
			end
		end
		local function aK(aF)
			if ay == s then
				return q
			else
				local aL = an[t.s]:GetGuiObjectsAtPosition(ay.X, ay.Y)
				return l.find(aL, aF) ~= s
			end
		end
		local function aM()
			if aB ~= s then
				local aF = ax[aB]
				for J, aH in p(aF[t.aq]) do
					aH(q)
				end
				aB = s
			end
		end
		local function aN()
			if ay == s then
				aA = {}
			else
				aA = an[t.s]:GetGuiObjectsAtPosition(ay.X, ay.Y)
			end
			local aO = az
			local aP = {}
			local aQ
			for J, aR in p(aA) do
				local aS = ax[aR]
				local aJ = l.find(aO, aR)
				if aJ ~= s then
					l[t.cf](aO, aJ)
				elseif aS ~= s then
					l[t.fg](aP, aR)
				end
				if aS ~= s and #aS[t.aq] > 0 then
					if not aC and aQ == s then
						aQ = aR
					end
				end
			end
			for J, aR in p(aO) do
				local aF = ax[aR]
				if aF ~= s then
					if aB == aR then
						for J, aH in p(aF[t.aq]) do
							aH(q)
						end
						aB = s
					end
					for J, aH in p(aF[t.ap]) do
						aH(q)
					end
				end
			end
			if aQ ~= aB and aB ~= s then
				local aF = ax[aB]
				if aF ~= s then
					for J, aH in p(aF[t.aq]) do
						aH(q)
					end
				end
			end
			for aa = #aP, 1, -1 do
				local aR = aP[aa]
				local aF = ax[aR]
				if aF ~= s and #aF[t.ap] > 0 then
					for J, aH in p(aF[t.ap]) do
						aH(r)
					end
				end
			end
			if aQ ~= aB and aQ ~= s then
				local aF = ax[aQ]
				if aF ~= s then
					for J, aH in p(aF[t.aq]) do
						aH(r)
					end
				end
			end
			aB = aQ
			az = aA
		end
		local function aT()
			aD = aD + 1
			for J, aR in p(az) do
				local aF = ax[aR]
				if aF ~= s then
					local aU = q
					aF[t.fv] = aD
					for J, aH in p(aF[t.ar]) do
						if aH() == q then
							aU = r
						end
					end
					if aU then
						return r
					end
				end
			end
			for J, aH in p(ax["*"][t.ar]) do
				aH()
			end
			return q
		end
		local aV
		local function aW()
			local aX = q
			local aY = q
			local aZ = q
			aV = s
			for J, aR in p(az) do
				local aF = ax[aR]
				if aF ~= s then
					if not aY then
						for J, aH in p(aF.OnUp) do
							if aH() == q then
								aX = r
								aY = r
							end
						end
					end
					if not aZ and aF[t.fv] == aD then
						aX = r
						for J, aH in p(aF[t.at]) do
							if aH() == q then
								aZ = r
							end
						end
					end
					if aY and aZ then
						break
					end
				end
			end
			for J, aH in p(ax["*"].OnUp) do
				aH()
			end
			for J, aH in p(ax["*"][t.at]) do
				aH()
			end
			aD = aD + 1
			return aX
		end
		local function a_(b0, b1)
			local b2 = f(b0, b1)
			local aX = q
			local aU = q
			if aV ~= s then
				if aV(b2) == q then
					aX = r
				end
			end
			if not aV then
				for J, aR in p(az) do
					local aF = ax[aR]
					if aF ~= s then
						if aF[t.fv] == aD then
							for J, aH in p(aF[t.au]) do
								if aH(b2) == q then
									aV = aH
									aX = r
									aD = aD + 1
									break
								end
							end
						end
						if aX then
							break
						end
					end
				end
			end
			for J, aH in p(ax["*"][t.au]) do
				aH(b2)
			end
			return aX
		end
		at:BindActionAtPriority(t.aA, function(b3, b4, b5)
			if b5[t.fw] == i[t.fw][t.fx] or b5[t.fw] == i[t.fw][t.fy] then
				ay = f(b5[t.cN].X, b5[t.cN].Y)
				local b2 = ay + av
				aN()
				if b5[t.fw] == i[t.fw][t.fy] then
					if a_(b2.X, b2.Y) then
						return i[t.fz].Sink
					end
				end
			else
				ay = s
				aN()
			end
			return i[t.fz].Pass
		end, q, 999999, i[t.fC][t.fD])
		at:BindActionAtPriority(t.aB, function(b3, b4, b5)
			if b5[t.fw] == i[t.fw][t.fx] then
				if aT() then
					return i[t.fz].Sink
				end
			elseif b5[t.fw] == i[t.fw].End then
				if aW() then
					return i[t.fz].Sink
				end
			end
			return i[t.fz].Pass
		end, q, 999998, i[t.fC][t.fF])
		at:BindActionAtPriority(t.aC, function(b3, b4, b5)
			if b5[t.fw] == i[t.fw][t.fx] or b5[t.fw] == i[t.fw][t.fy] then
				ay = f(b5[t.cN].X, b5[t.cN].Y)
				local b2 = ay + av
				aN()
				if b5[t.fw] == i[t.fw][t.fx] then
					if aT() then
						return i[t.fz].Sink
					end
				elseif b5[t.fw] == i[t.fw][t.fy] then
					if a_(b2.X, b2.Y) then
						return i[t.fz].Sink
					end
				end
			else
				if b5[t.fw] == i[t.fw].End then
					if aW() then
						ay = s
						aN()
						return i[t.fz].Sink
					end
				end
				ay = s
				aN()
			end
			return i[t.fz].Pass
		end, q, 999999, i[t.fC][t.fG])
		local b6
		aw[t.fH] = function(aF, aH)
			local b7 = aE(aF, t.ap, aH)
			if aK(aF) then
				aH(r)
			end
			return b7
		end
		aw[t.fI] = function(aF, aH)
			local b7 = aE(aF, t.aq, aH)
			al[t.fp](b6)
			b6 = al[t.fo](aN, 10)
			return b7
		end
		aw[t.fJ] = function(aF, aH)
			return aE(aF, t.ar, aH)
		end
		aw.onUp = function(aF, aH)
			return aE(aF, t.as, aH)
		end
		aw[t.fL] = function(aF, aH)
			return aE(aF, t.at, aH)
		end
		aw[t.fM] = function(aF, aH)
			return aE(aF, t.au, aH)
		end
		aw[t.fN] = function(aF, aH, b8)
			local b9 = q
			local ba
			local bb
			if b8 == s then
				b8 = 0
			end
			local bc
			local bd = aw[t.fJ](aF, function()
				bb = aw[t.fM](aF, function(b2)
					if not b9 and bc == s then
						bc = b2
					end
					local be = b2 - bc
					if b9 then
						aH(t.aD, bc, b2, be)
					elseif not b9 and (d(be.X) >= b8 or d(be.Y) >= b8) then
						aC = r
						aM()
						b9 = r
						aH(t.aE, bc)
					end
					return not b9
				end)
				ba = aw.onUp("*", function()
					if ba ~= s then
						ba()
					end
					if bb ~= s then
						bb()
					end
					if b9 then
						aC = q
						al[t.fo](aN)
						aH("end")
					end
					ba = s
					bb = s
					b9 = q
					bc = s
				end)
			end)
			return function()
				if b9 then
					aC = q
					al[t.fo](aN)
					aH("end")
				end
				bd()
				if ba ~= s then
					ba()
				end
				if bb ~= s then
					bb()
				end
			end
		end
		local bf = 1
		aw[t.fO] = function(aF, aH)
			local bg
			bf = bf + 1
			local bh = t.aI .. bf
			local bi = aw[t.fH](aF, function(bj)
				at:UnbindAction(bh)
				if bg ~= s then
					bg()
					bg = s
				end
				if bj then
					at:BindActionAtPriority(bh, function(bh, bk, b5)
						if b5[t.fw] ~= i[t.fw][t.fy] then
							return i[t.fz].Pass
						end
						aH(b5[t.cN].Z * 50)
						return i[t.fz].Sink
					end, q, 999999999, i[t.fC][t.fP])
					local b1
					bg = aw[t.fN](aF, function(aG, bl, b2, be)
						if aG == t.aE then
							b1 = bl.Y
						elseif aG == t.aD then
							aH((b2.Y - b1) * 3)
							b1 = b2.Y
						end
					end, 20)
				end
			end)
			return function()
				bi()
				at:UnbindAction(bh)
				if bg ~= s then
					bg()
					bg = s
				end
			end
		end
		return aw
	end
	D[5] = function()
		local a2 = w
		local as = x
		local at = y
		local am = v
		local an = am[t.r] or am:GetPropertyChangedSignal(t.r):Wait()
		local bm = an:GetMouse()
		local G = E(2)
		local bn = E(6)
		local aw = E(7)
		local bo = {}
		bo[t.fQ] = function(bp)
			local bq = k(t.aK)
			bq.Name = t.aL
			bq[t.fR] = f(0, 0)
			bq[t.fS] = 1
			bq[t.fT] = 0
			bq[t.fU] = q
			bq[t.cN] = h(0, 4, 0, 3)
			bq.Size = h(1, -8, 1, -6)
			bq[t.fV] = i[t.fV][t.fW]
			bq[t.fX] = r
			bq[t.fY] = 2
			bq[t.fZ] = r
			bq[t.ga] = bp
			bq[t.gb] = bn[t.M]
			bq[t.gc] = 0
			bq[t.gd] = i[t.gd][t.ge]
			bq[t.gf] = 1
			return bq
		end
		bo[t.gg] = function(br)
			local bs = k(t.aM)
			bs[t.fR] = f(0, 0)
			bs[t.cN] = h(0, 0, 0, 0)
			bs.Size = h(1, 0, 1, 0)
			bs[t.gh] = bn[t.z]
			bs[t.fS] = 0
			bs[t.gi] = i[t.gi][t.gj]
			bs[t.fT] = 0
			bs[t.gk] = q
			bs[t.fU] = q
			bs[t.fV] = i[t.fV][t.fW]
			bs[t.gl] = i[t.gm][t.gn]
			bs[t.fY] = 1
			bs[t.fX] = r
			bs[t.fZ] = r
			if br ~= s then
				for bt, P in pairs(br) do
					bs[bt] = P
				end
			end
			return bs
		end
		bo[t.go] = function(br)
			local bu = k(t.aN)
			bu.Name = t.aO
			bu[t.fR] = f(0, 0)
			bu[t.gp] = i[t.gp].None
			bu[t.fS] = 1
			bu[t.gi] = i[t.gi][t.gj]
			bu[t.fT] = 0
			bu[t.cN] = h(0, 0, 0, 0)
			bu[t.fU] = q
			bu.Size = h(1, 0, 1, 0)
			bu[t.fV] = i[t.fV][t.fW]
			bu[t.fX] = r
			bu[t.fY] = 1
			bu[t.fZ] = r
			bu.Font = i.Font[t.gs]
			bu[t.gt] = 1
			bu[t.gu] = q
			bu.Text = ""
			bu[t.gv] = bn[t.E]
			bu[t.gw] = q
			bu[t.gx] = 14
			bu[t.gy] = 1
			bu[t.gz] = 0
			bu[t.gA] = i[t.gA][t.gB]
			bu[t.gC] = q
			bu[t.gD] = i[t.gD].Left
			bu[t.gF] = i[t.gF][t.gG]
			if br ~= s then
				for bt, P in pairs(br) do
					bu[bt] = P
				end
			end
			return bu
		end
		bo[t.gH] = function(bv)
			if bv[t.dm] == s then
				bv[t.dm] = 30
			end
			if bv[t.cu] == s then
				bv[t.cu] = g[t.eX](27, 42, 53)
			end
			local bw = bo[t.gg]()
			bw.Name = bv.Name
			bw.Size = h(1, 0, 0, bv[t.dm])
			local bx = k(t.aQ)
			bx.Name = t.aR
			bx[t.aY] = q
			bx[t.fu] = bw
			local by = k(t.aQ)
			by.Name = t.aS
			by[t.aY] = r
			by[t.fu] = bw
			local bz = k(t.aT)
			bz.Name = t.aU
			bz[t.fu] = bw
			local bA = bo[t.go]()
			bA[t.cN] = h(0, 6, 0, 0)
			bA.Size = h(0.4, -6, 1, -1)
			bA[t.fu] = bw
			local bB = bo[t.gg]()
			bB.Name = t.aV
			bB[t.gh] = bn[t.C]
			bB[t.cN] = h(0, 0, 1, -1)
			bB.Size = h(1, 0, 0, 1)
			bB[t.fu] = bw
			local bC = bo[t.gg]()
			bC.Name = t.aW
			bC[t.gh] = bv[t.cu]
			bC.Size = h(0, 3, 1, 0)
			bC[t.fY] = 2
			bC[t.fu] = bw
			local bD = bo[t.gg]()
			bD.Name = t.aX
			bD[t.fS] = 1
			bD[t.cN] = h(0.4, 0, 0, 0)
			bD.Size = h(0.6, 0, 1, -1)
			bD[t.fu] = bw
			local H = {}
			l[t.fg](
				H,
				bz[t.gI]:Connect(function()
					bA.Text = bz[t.aY]
				end)
			)
			l[t.fg](
				H,
				by[t.gI]:Connect(function()
					bA[t.fX] = by[t.aY]
					if by[t.aY] then
						bD[t.cN] = h(0.4, 0, 0, 0)
						bD.Size = h(0.6, 0, 1, -1)
					else
						bD[t.cN] = h(0, 6, 0, 0)
						bD.Size = h(1, -6, 1, -1)
					end
				end)
			)
			return bw, bD, G[t.eQ](H)
		end
		local bE = function(bF)
			return bF
		end
		local bG = bE
		bo[t.gJ] = function(bv)
			if bv[t.cu] == s then
				bv[t.cu] = bn[t.O]
			end
			if bv[t._do] == s then
				bv[t._do] = q
			end
			if bv[t.dD] == s then
				bv[t.dD] = bE
			end
			if bv[t.dE] == s then
				bv[t.dE] = bG
			end
			if bv[t.cC] == s then
				bv[t.cC] = r
			end
			local bH = k(t.aT)
			bH.Name = t.aY
			local bI = bo[t.gg]()
			bI.Name = t.aZ
			bI[t.gh] = bn[t.R]
			bI.Size = h(1, 0, 1, 0)
			local bJ = k(t.ba)
			bJ.Name = t.ba
			bJ.Text = ""
			bJ[t.fR] = f(0, 0)
			bJ[t.fS] = 1
			bJ[t.gi] = i[t.gi][t.gj]
			bJ[t.fT] = 0
			bJ[t.gK] = q
			bJ[t.gL] = 1
			bJ[t._do] = bv[t._do]
			bJ[t.cN] = h(0, 2, 0, 0)
			bJ.Size = h(1, -4, 1, 0)
			bJ[t.gM] = -1
			bJ[t.gN] = r
			bJ[t.fV] = i[t.fV][t.fW]
			bJ[t.fU] = q
			bJ[t.fX] = q
			bJ[t.gO] = q
			bJ[t.cB] = q
			bJ[t.fZ] = q
			bJ[t.fY] = 1
			bJ.Font = i.Font[t.gs]
			bJ[t.gt] = 1
			bJ[t.gu] = q
			bJ[t.gv] = bv[t.cu]
			bJ[t.gw] = q
			bJ[t.gx] = 14
			bJ[t.gy] = 1
			bJ[t.gz] = 0
			bJ[t.gA] = i[t.gA].None
			bJ[t.gC] = q
			bJ[t.gD] = i[t.gD].Left
			bJ[t.gF] = i[t.gF][t.gG]
			if bv[t._do] then
				bJ[t.gF] = i[t.gF].Top
			end
			bJ[t.fu] = bI
			local bK = bo[t.go]()
			bK.Name = t.bc
			bK[t.cN] = bJ[t.cN]
			bK[t.gD] = bJ[t.gD]
			bK[t.gF] = bJ[t.gF]
			bK[t.gv] = bJ[t.gv]
			bK.Size = bJ.Size
			bK[t.fu] = bI
			local H = {}
			local bL = q
			local bM = q
			local bN = k(t.bd)
			local bO = k(t.bd)
			local bP
			local function bQ()
				if bL and not bv[t.aR][t.aY] then
					if bv[t.cC] then
						bJ[t.gv] = bn[t.U]
						bI[t.gh] = bn[t.T]
					end
				else
					if bM and not bv[t.aR][t.aY] then
						bK[t.fY] = -1
						bK[t.fX] = q
						bJ[t.fU] = r
						bJ[t.fX] = r
						bJ[t.gO] = r
						bJ[t.cB] = r
					else
						bK[t.fY] = 2
						bK[t.fX] = r
						bJ[t.fU] = q
						bJ[t.fX] = q
						bJ[t.gO] = q
						bJ[t.cB] = q
					end
					if bv[t.cC] then
						if bM and not bv[t.aR][t.aY] then
							bI[t.gh] = bn[t.S]
						else
							bJ[t.gv] = bv[t.cu]
							bI[t.gh] = bn[t.R]
						end
					end
				end
			end
			l[t.fg](
				H,
				bH[t.gI]:Connect(function()
					bJ.Text = bv[t.dD](bH[t.aY])
					bK.Text = bJ.Text
				end)
			)
			l[t.fg](
				H,
				bJ[t.gQ]:Connect(function()
					bL = r
					bQ()
					bN:Fire()
				end)
			)
			l[t.fg](
				H,
				bJ[t.gR]:Connect(function(bR, b5)
					bL = q
					bQ()
					bH[t.aY] = bv[t.dE](bJ.Text, bH)
					bJ.Text = bv[t.dD](bH[t.aY])
					bK.Text = bJ.Text
					bO:Fire()
				end)
			)
			l[t.fg](
				H,
				aw[t.fI](bI, function(bS)
					bM = bS
					bQ()
				end)
			)
			return bH, bI, bN[t.gS], bO[t.gS], G[t.eQ](H)
		end
		bo[t.gT] = function(bv)
			if bv.Min == s then
				bv.Min = -a
			end
			if bv.Max == s then
				bv.Max = a
			end
			local bH = k(t.be)
			bH.Name = t.aY
			local bT = k(t.be)
			bT.Name = "Min"
			bT[t.aY] = -a
			local bU = k(t.be)
			bU.Name = "Max"
			bU[t.aY] = a
			local bV = k(t.be)
			bV.Name = t.bh
			bV[t.aY] = 0
			local bW = bo[t.gg]()
			bW.Name = t.bi
			bW[t.gh] = g[t.eX](60, 60, 60)
			bW[t.fS] = 0
			bW[t.gi] = i[t.gi][t.gj]
			local bX = bo[t.gg]()
			bX.Name = t.bj
			bX[t.gh] = bn[t.O]
			bX[t.fS] = 0
			bX.Size = h(0, 0, 1, 0)
			bX[t.fu] = bW
			local H = {}
			local bY, bZ, b_, c0, b0, b1
			local bM = q
			local b9 = q
			local bN = k(t.bd)
			local bO = k(t.bd)
			local function c1()
				if not bv[t.aR][t.aY] and (bM or b9) then
					bW[t.gh] = bn[t.S]
					bX[t.gh] = bn[t.P]
				else
					bW[t.gh] = bn[t.R]
					bX[t.gh] = bn[t.O]
				end
			end
			l[t.fg](
				H,
				aw[t.fI](bW, function(bS)
					bM = bS
					c1()
				end)
			)
			l[t.fg](
				H,
				aw[t.fN](bW, function(aG, bl, b2, be)
					if bv[t.aR][t.aY] then
						return
					end
					if aG == t.aE then
						b9 = r
						c1()
						bN:Fire()
					elseif aG == "end" then
						b9 = q
						c1()
						bO:Fire()
					elseif aG == t.aD then
						bY = bW[t.gW].X
						bZ = bW[t.gW].Y
						b_ = bW[t.gX].X
						c0 = bW[t.gX].Y
						b0 = b2.X
						b1 = b2.Y
						if b0 < bY then
							bV[t.aY] = 0
						elseif b0 > bY + b_ then
							bV[t.aY] = 1
						else
							bV[t.aY] = (b0 - bY) / b_
						end
					end
				end)
			)
			l[t.fg](
				H,
				bV[t.gI]:Connect(function()
					bX.Size = h(bV[t.aY], 0, 1, 0)
					spawn(function()
						bH[t.aY] = G[t.eW](bV[t.aY], 0, 1, bT[t.aY], bU[t.aY])
					end)
				end)
			)
			l[t.fg](
				H,
				bH[t.gI]:Connect(function()
					local P = math[t.gY](bH[t.aY], bT[t.aY], bU[t.aY])
					if P ~= bH[t.aY] then
						spawn(function()
							bH[t.aY] = math[t.gY](bH[t.aY], bT[t.aY], bU[t.aY])
						end)
					else
						spawn(function()
							bV[t.aY] = G[t.eW](bH[t.aY], bT[t.aY], bU[t.aY], 0, 1)
						end)
					end
				end)
			)
			l[t.fg](
				H,
				bT[t.gI]:Connect(function()
					bH[t.aY] = math[t.gY](bH[t.aY], bT[t.aY], bU[t.aY])
					spawn(function()
						bV[t.aY] = G[t.eW](bH[t.aY], bT[t.aY], bU[t.aY], 0, 1)
					end)
				end)
			)
			l[t.fg](
				H,
				bU[t.gI]:Connect(function()
					bH[t.aY] = math[t.gY](bH[t.aY], bT[t.aY], bU[t.aY])
					spawn(function()
						bV[t.aY] = G[t.eW](bH[t.aY], bT[t.aY], bU[t.aY], 0, 1)
					end)
				end)
			)
			bT[t.aY] = bv.Min
			bU[t.aY] = bv.Max
			bH[t.aY] = bv[t.aY]
			return bW, bH, bT, bU, bV, bN[t.gS], bO[t.gS], G[t.eQ](H)
		end
		return bo
	end
	D[4] = function()
		local bo = E(5)
		local bn = E(6)
		local c2 = 0
		local c3 = {}
		c3[t.gZ] = c3
		c3.new = function(c4, c5, b2, b8)
			local bs = bo[t.gg]()
			c2 = c2 + 1
			bs.Name = t.bm .. c2
			bs[t.fu] = bn[t.y]
			bs.Size = h(0, c5.X, 0, c5.Y)
			bs[t.fS] = 1
			bs[t.fX] = q
			bs[t.fY] = 1000
			if b2 == s or b2 == "" then
				b2 = "top"
			end
			if b8 == s then
				b8 = 0
			end
			return setmetatable({ [t.bp] = c4, [t.bq] = b2, [t.br] = b8, [t.aM] = bs }, c3)
		end
		function c3:resize(c5)
			self[t.aM].Size = h(0, c5.X, 0, c5.Y)
			if self[t.aM][t.fX] then
				self:show()
			end
		end
		function c3:show(c6, c7)
			local c8 = self[t.bp][t.gW]
			local c9 = self[t.bp][t.gX]
			local ca = f(bn[t.x][t.gX].X, bn[t.x][t.gX].Y)
			local c5 = self[t.aM][t.gX]
			local b0
			local b1
			local b8 = self[t.br]
			local cb = self[t.bq]
			if self[t.bq] == "top" then
				b0 = c8.X + c9.X / 2 - c5.X / 2
				b1 = c8.Y - c5.Y - self[t.br]
				if b1 < -bn[t.w] then
					b1 = c8.Y + c9.Y + self[t.br]
					cb = t.bt
				end
			elseif self[t.bq] == t.bt then
				b0 = c8.X + c9.X / 2 - c5.X / 2
				b1 = c8.Y + c9.Y + self[t.br]
				if b1 + c5.Y > ca.Y - bn[t.w] then
					b1 = c8.Y - c5.Y - self[t.br]
					cb = "top"
				end
			elseif self[t.bq] == t.bv then
				b1 = c8.Y + c9.Y / 2 - c5.Y / 2
				if b1 < -bn[t.w] then
					b1 = -bn[t.w]
				end
				if b1 + c5.Y > ca.Y - bn[t.w] then
					b1 = ca.Y - bn[t.w] - c5.Y
				end
				b0 = c8.X - c5.X - self[t.br]
				if b0 < 0 then
					b0 = c8.X + c9.X + self[t.br]
					cb = t.bw
				end
			else
				b1 = c8.Y + c9.Y / 2 - c5.Y / 2
				if b1 < -bn[t.w] then
					b1 = -bn[t.w]
				end
				if b1 + c5.Y > ca.Y - bn[t.w] then
					b1 = ca.Y - bn[t.w] - c5.Y
				end
				b0 = c8.X + c9.X + self[t.br]
				if b0 + c5.X > ca.X then
					b0 = c8.X - c5.X - self[t.br]
					cb = t.bv
				end
			end
			self[t.aM][t.cN] = h(0, b0, 0, b1 + bn[t.w])
			self[t.aM][t.fX] = r
			if c6 == r then
				local cc = 10
				if self[t.ha] == s then
					self[t.ha] = bo[t.fQ](bn[t.X])
					self[t.ha].Name = t.bx
					self[t.ha].Size = h(0, cc, 0, cc)
					self[t.ha][t.gb] = bn[t.E]
					self[t.ha][t.fu] = self[t.aM]
				end
				if c7 ~= s then
					self[t.ha][t.gb] = c7
				end
				if cb == "top" then
					self[t.ha][t.cN] = h(0.5, -cc / 2, 1, 0)
					self[t.ha][t.hb] = 90
				elseif cb == t.bt then
					self[t.ha][t.cN] = h(0.5, -cc / 2, 0, -cc)
					self[t.ha][t.hb] = -90
				elseif cb == t.bv then
					self[t.ha][t.cN] = h(1, 0, 0.5, -cc / 2)
					self[t.ha][t.hb] = 0
				else
					self[t.ha][t.cN] = h(0, -cc, 0.5, -cc / 2)
					self[t.ha][t.hb] = -180
				end
			else
				if self[t.ha] ~= s then
					self[t.ha][t.fu] = s
				end
			end
		end
		function c3:hide()
			self[t.aM][t.fX] = q
		end
		function c3:destroy()
			self[t.aM][t.fu] = s
			self[t.aM] = s
			self[t.bp] = s
		end
		return c3
	end
	D[8] = function()
		local cd = A
		local G = E(2)
		local bo = E(5)
		local aw = E(7)
		local bn = E(6)
		local ce = {}
		ce[t.gZ] = ce
		local cf = 5
		local cg = j(0.2, i[t.hc][t.hd], i[t.he].Out)
		ce.new = function(ch, ci, cj)
			if cj == s then
				cj = 0
			end
			local ck = bo[t.gg]()
			ck.Name = t.bA
			ck[t.gh] = bn[t.z]
			ck[t.fS] = 0
			ck[t.cN] = h(1, -cf, 0, cj)
			ck[t.fu] = ch
			local cl = bo[t.gg]()
			cl.Name = t.bB
			cl[t.gh] = bn[t.B]
			cl[t.fS] = 0
			cl[t.cN] = h(0, 0, 0, 0)
			cl.Size = h(1, 0, 0, 0)
			cl[t.fu] = ck
			local cm = k(t.be)
			cm.Name = t.bC
			cm[t.aY] = 0
			cm[t.fu] = ck
			local cn = k(t.be)
			cn.Name = t.bD
			cn[t.aY] = 0
			cn[t.fu] = ck
			local co = k(t.bE)
			co.Name = t.bF
			co[t.aY] = 0
			co[t.fu] = ck
			local cp = q
			local cq, cr
			local function cs()
				if ck[t.fX] == q then
					return
				end
				if cq ~= s then
					cq:Cancel()
				end
				cq = cd:Create(cl, j(0.2, i[t.hc][t.hd], i[t.he].Out), { Position = h(0.3, 0, cm[t.aY] / cn[t.aY], 0) })
				cq:Play()
			end
			local function ct()
				local cu = (ch[t.gX].Y - cj) / cn[t.aY]
				if cu >= 1 then
					cl[t.fX] = q
					ck.Size = h(0, cf, 0, cn[t.aY])
				else
					cl[t.fX] = r
					ck.Size = h(0, cf, 1, -cj)
					if cr ~= s then
						cr:Cancel()
					end
					cr = cd:Create(cl, cg, { [t.bG] = h(1, 0, cu, 0) })
					cr:Play()
					cs()
				end
			end
			local H = {}
			l[t.fg](H, co[t.gI]:connect(ct))
			l[t.fg](H, cn[t.gI]:connect(ct))
			l[t.fg](H, cm[t.gI]:connect(cs))
			local self =
				setmetatable({ [t.bH] = ch, [t.bI] = ci, [t.bJ] = co, [t.bK] = cn, [t.bL] = cm, [t.bM] = cj }, ce)
			self[t.hg] = G[t.eQ](H, function()
				if self[t.hh] ~= s then
					self[t.hh]()
				end
				if self[t.hi] ~= s then
					self[t.hi]:Cancel()
				end
				if cq ~= s then
					cq:Cancel()
				end
				if cr ~= s then
					cr:Cancel()
				end
				ck[t.fu] = s
			end)
			return self
		end
		function ce:destroy()
			self[t.hg]()
		end
		function ce:update()
			if self[t.hh] ~= s then
				self[t.hh]()
				self[t.hh] = s
			end
			local cv = self[t.bH].Size.Y[t.hj]
			local cn = self[t.bI][t.gX].Y
			if cn > cv - self[t.bM] then
				self[t.bI].Size = h(1, -cf, 0, cn)
				local cw = -(cn - cv)
				if self[t.bI][t.cN].Y[t.hj] ~= 0 then
					local cx = c(b(self[t.bI][t.cN].Y[t.hj], cw), 0)
					if self[t.hi] ~= s then
						self[t.hi]:Cancel()
					end
					self[t.hi] = cd:Create(self[t.bI], cg, { Position = h(0, 0, 0, cx) })
					self[t.hi]:Play()
					self[t.bL][t.aY] = -cx
				end
				self[t.hh] = aw[t.fO](self[t.bH], function(cy)
					local cx = c(b(self[t.bI][t.cN].Y[t.hj] + cy, cw), 0)
					if self[t.hi] ~= s then
						self[t.hi]:Cancel()
					end
					self[t.hi] = cd:Create(self[t.bI], cg, { Position = h(0, 0, 0, cx) })
					self[t.hi]:Play()
					self[t.bL][t.aY] = -cx
				end)
			else
				self[t.bL][t.aY] = 0
				self[t.bI].Size = h(1, -cf, 1, 0)
				if self[t.bI][t.cN].Y[t.hj] ~= 0 then
					if self[t.hi] ~= s then
						self[t.hi]:Cancel()
					end
					self[t.hi] = cd:Create(self[t.bI], cg, { Position = h(0, 0, 0, 0) })
					self[t.hi]:Play()
				end
			end
			self[t.bK][t.aY] = cn - self[t.bM]
			self[t.bJ][t.aY] = self[t.bH][t.gX].Y
		end
		return ce
	end
	D[1] = function()
		local am = v
		local an = am[t.r] or am:GetPropertyChangedSignal(t.r):Wait()
		local bm = an:GetMouse()
		local G = E(2)
		local al = E(3)
		local c3 = E(4)
		local bn = E(6)
		local aw = E(7)
		local bo = E(5)
		local ce = E(8)
		local cz = 250
		local cA = 500
		local cB = 60
		local cC = 30
		local cD = 15
		local cE = 10
		local cF = 5
		local cG = cE + cF * 2
		local cH = (cC - cG) / 2
		local cI = 0
		local cJ = 0
		local cK = {}
		local cL = {}
		local cM = {}
		cM[t.gZ] = cM
		cM[t.hk] = cz
		cM.new = function()
			cI = cI + 1
			local a3 = cI
			local ck = bo[t.gg]()
			ck.Name = t.bO
			ck.Size = h(0, 250, 0, 250)
			ck[t.fS] = 0.95
			ck[t.hl] = r
			ck[t.hm] = 0
			local cN = bo[t.gg]()
			cN.Name = t.bP
			cN[t.fS] = 1
			cN[t.cN] = h(0, 5, 0, cC)
			cN.Size = h(1, -5, 0, -cC)
			cN[t.fu] = ck
			local cO = bo[t.gg]()
			cO.Name = t.bQ
			cO[t.gh] = bn[t.H]
			cO.Size = h(1, 0, 0, cC)
			cO[t.fu] = ck
			local cP = bo[t.gg]()
			cP.Name = t.aV
			cP[t.gh] = bn[t.C]
			cP[t.cN] = h(0, 0, 1, -1)
			cP.Size = h(1, 0, 0, 1)
			cP[t.fY] = 1
			cP[t.fu] = cO
			local bA = bo[t.go]()
			bA.Name = t.aU
			bA[t.cN] = h(0, 16, 0, 0)
			bA.Size = h(1, -16, 1, -1)
			bA[t.fu] = cO
			local cQ = k(t.bd)
			local cR = k(t.aQ)
			cR.Name = t.bR
			cR[t.aY] = q
			cR[t.fu] = ck
			local cS = k(t.aT)
			cS.Name = t.aU
			cS[t.fu] = ck
			local cT = setmetatable(
				{
					["_id"] = a3,
					[t.bT] = q,
					[t.bU] = q,
					[t.bV] = cQ,
					[t.bW] = {},
					[t.bR] = cR,
					[t.aU] = cS,
					[t.aO] = bA,
					[t.aM] = ck,
					[t.bP] = cN,
					[t.bQ] = cO,
				},
				cM
			)
			ck:SetAttribute(t.bX, r)
			ck:SetAttribute(t.bY, a3)
			ck:SetAttribute(t.bZ, q)
			local H = {}
			local cU = 0
			l[t.fg](
				H,
				cN[t.hn]:Connect(function(cV)
					local cW = cV:GetAttribute(t.ca .. a3)
					if cW == s then
						cW = cU
						cU = cU + 1
					end
					cV[t.hm] = cW
					cV:SetAttribute(t.ca .. a3, cW)
				end)
			)
			l[t.fg](
				H,
				aw[t.fJ](cO, function(cX, b5)
					if cT[t.bT] == r then
						cJ = cJ + 1
						ck[t.fY] = cJ
					end
				end)
			)
			l[t.fg](
				H,
				aw[t.fL](cO, function()
					cR[t.aY] = not cR[t.aY]
					return q
				end)
			)
			l[t.fg](
				H,
				cR[t.gI]:connect(function()
					ck:SetAttribute(t.bZ, cR[t.aY])
					cT:updateContentSize()
				end)
			)
			l[t.fg](
				H,
				cS[t.gI]:connect(function()
					bA.Text = cS[t.aY]
				end)
			)
			local function cY()
				cT:updateContentSize()
			end
			l[t.fg](H, cN[t.hn]:Connect(cY))
			l[t.fg](H, cN[t.ho]:Connect(cY))
			cT[t.hg] = G[t.eQ](H, function()
				ck[t.fu] = s
			end)
			cL[cT._id] = cT
			return cT
		end
		function cM:addAction(bv)
			local bs = bo[t.gg]()
			bs.Name = t.cb
			bs[t.cN] = h(0, cH, 0, 0)
			bs.Size = h(0, cG, 0, cG)
			bs[t.fS] = 1
			bs[t.fu] = self[t.bQ]
			local cZ = bo[t.fQ](bv.icon)
			cZ.Name = t.aL
			cZ[t.cN] = h(0, cF, 0, cF)
			cZ.Size = h(0, cE, 0, cE)
			cZ[t.gc] = 0.7
			cZ[t.fu] = bs
			local W = bv[t.hr]
			if W == s then
				W = bn[t.E]
			end
			local c_ = bv[t.hs]
			if c_ == s then
				c_ = W
			end
			cZ[t.gb] = W
			local H = {}
			local d0 = s
			if bv[t.ht] ~= s then
				local bF = bo[t.go]()
				bF[t.gh] = bn[t.z]
				bF[t.fS] = 0
				bF[t.fT] = 1
				bF[t.hu] = bn[t.C]
				bF.Name = t.cc
				bF[t.gC] = r
				bF[t.gu] = r
				bF[t.gD] = i[t.gD][t.gG]
				bF.Text = bv[t.ht]
				bF[t.fu] = bn[t.x]
				d0 = c3.new(bs, bF[t.hv] + f(4, 2), "top", 0)
				bF[t.fu] = d0[t.aM]
			end
			l[t.fg](
				H,
				aw[t.fI](bs, function(bS)
					if bS then
						cZ[t.gb] = c_
						cZ[t.gc] = 0
						if d0 ~= s then
							d0:show()
						end
					else
						cZ[t.gb] = W
						cZ[t.gc] = 0.7
						if d0 ~= s then
							d0:hide()
						end
					end
					if bv[t.fI] ~= s then
						bv[t.fI](bS)
					end
				end)
			)
			if bv[t.fL] ~= s then
				l[t.fg](
					H,
					aw[t.fL](bs, function()
						bv[t.fL]()
						return q
					end)
				)
			end
			local b3
			b3 = {
				[t.ce] = bs,
				[t.cf] = G[t.eQ](H, function()
					bs[t.fu] = s
					local aJ = l.find(self[t.bW], b3)
					if aJ ~= s then
						l[t.cf](self[t.bW], aJ)
					end
					if d0 ~= s then
						d0:destroy()
						d0 = s
					end
					self:_updateActions()
				end),
			}
			l[t.fg](self[t.bW], b3)
			self:_updateActions()
			return b3
		end
		function cM:attachTo(ch, d1)
			if self[t.bT] == r then
				self[t.hw]()
			end
			if self[t.bU] == r then
				return
			end
			self[t.bU] = r
			local H = {}
			self[t.aM].Size = h(1, 0, 0, 250)
			self[t.aM][t.fX] = r
			self[t.aM][t.fS] = 1
			self[t.aM][t.fY] = 0
			self[t.bP][t.cN] = h(0, 5, 0, 0)
			self[t.aO][t.gD] = i[t.gD].Left
			local d2 = bo[t.fQ](bn[t.X])
			d2.Name = t.bx
			d2[t.cN] = h(0, 6, 0.5, -3)
			d2.Size = h(0, 5, 0, 5)
			d2[t.gb] = bn[t.E]
			d2[t.hb] = 90
			d2[t.fu] = self[t.bQ]
			self[t.aM][t.fu] = ch
			local function d3()
				if self[t.bR][t.aY] then
					d2[t.hb] = 0
				else
					d2[t.hb] = 90
				end
				self:updateContentSize()
			end
			d3()
			l[t.fg](H, self[t.bR][t.gI]:Connect(d3))
			if d1 ~= r then
				self[t.hx] = self:addAction({
					icon = bn[t.aj],
					title = t.cg,
					onClick = function()
						self:detach()
					end,
				})
			end
			self[t.hy] = G[t.eQ](H, function()
				self[t.bU] = q
				d2[t.fu] = s
				if self[t.hx] ~= s then
					local b3 = self[t.hx]
					self[t.hx] = s
					b3[t.cf]()
				end
				self[t.hz] = q
			end)
		end
		function cM:detach(d4)
			if self[t.bU] == r then
				if d4 ~= r then
					self[t.hA] = self[t.aM][t.fu]
				end
				self[t.hy]()
			end
			if self[t.bT] == r then
				return
			end
			self[t.bT] = r
			local H = {}
			self[t.aM][t.fX] = q
			self[t.aM][t.fS] = 0.95
			self[t.aO][t.gD] = i[t.gD][t.gG]
			self[t.bP][t.cN] = h(0, 0, 0, 0)
			cJ = cJ + 1
			self[t.aM][t.fY] = cJ
			local d5 = bo[t.fQ](t.ch)
			d5.Name = t.ci
			d5[t.cN] = h(0, 0, 1, 0)
			d5.Size = h(1, 0, 0, 20)
			d5[t.gb] = g[t.eX](0, 0, 0)
			d5[t.gc] = 0.5
			d5[t.fu] = self[t.bQ]
			local d6 = bo[t.gg]()
			d6.Name = t.cj
			d6[t.fS] = 1
			d6.Size = h(0, 20, 0, 20)
			d6[t.cN] = h(1, -17, 1, -17)
			d6[t.fY] = 10
			d6[t.fu] = self[t.aM]
			local d7 = bo[t.fQ](bn[t.ah])
			d7.Size = h(0, 11, 0, 11)
			d7[t.gb] = bn[t.E]
			d7[t.gc] = 0.8
			d7[t.fu] = d6
			local function d3()
				if self[t.bR][t.aY] then
					d6[t.fX] = q
				else
					d6[t.fX] = r
				end
				self:updateContentSize()
			end
			if d4 == r then
				self[t.hB] = self:addAction({
					icon = bn[t.Z],
					title = t.ck,
					colorHover = bn[t.G],
					onClick = function()
						self:destroy()
					end,
				})
			end
			local d8
			if self[t.hA] ~= s then
				local d9 = self[t.hA]
				self[t.hC] = self:addAction({
					icon = bn[t.aj],
					title = t.cl,
					onClick = function()
						self:attachTo(d9)
					end,
				})
				local da = self[t.aM][t.gX].X
				local db = self[t.aM][t.gX].Y
				local dc = self[t.aM][t.gW].X - (da + 10)
				if dc < 0 then
					dc = self[t.aM][t.gW].X + da + 10
				end
				local dd = self[t.aM][t.gW].Y + bn[t.w]
				al[t.fo](function()
					self:resize(da, db)
					self:move(dc, dd)
					d3()
				end, 0)
			end
			self[t.aM][t.fu] = bn[t.x]
			local de
			local df
			local dg
			local bM
			local dh
			local di
			d3()
			l[t.fg](H, self[t.bR][t.gI]:Connect(d3))
			l[t.fg](
				H,
				aw[t.fN](self[t.bQ], function(aG, bl, b2, be)
					if aG == t.aE then
						de = f(self[t.aM][t.cN].X[t.hj], self[t.aM][t.cN].Y[t.hj])
					elseif aG == "end" then
						de = s
					elseif aG == t.aD then
						local dj = de + be
						self:move(dj.X, dj.Y)
					end
				end, 10)
			)
			local function dk()
				if bM or dh then
					if di == s then
						di = bm.Icon
					end
					bm.Icon = dg
					d7[t.gc] = 0
				else
					bm.Icon = di or ""
					d7[t.gc] = 0.8
				end
			end
			l[t.fg](
				H,
				aw[t.fI](d6, function(bS)
					bM = bS
					if bS then
						dg = bn[t.al]
					end
					dk()
				end)
			)
			l[t.fg](
				H,
				aw[t.fN](d6, function(aG, bl, b2, be)
					if aG == t.aE then
						dh = r
						df = f(self[t.aM].Size.X[t.hj], self[t.aM].Size.Y[t.hj])
						dk()
					elseif aG == "end" then
						dh = q
						df = s
						dk()
					elseif aG == t.aD then
						local dl = df + be
						self:resize(dl.X, dl.Y)
					end
				end)
			)
			l[t.fg](
				H,
				bn[t.x][t.gI]:Connect(function()
					local ac = self[t.aM][t.gW]
					self:move(ac.X, ac.Y)
				end)
			)
			self[t.hD] = ce.new(self[t.aM], self[t.bP], cC)
			self:updateContentSize()
			self[t.hw] = G[t.eQ](H, function()
				self[t.hD]:destroy()
				d6[t.fu] = s
				d5[t.fu] = s
				if self[t.hC] ~= s then
					local b3 = self[t.hC]
					self[t.hC] = s
					b3[t.cf]()
				end
				if self[t.hB] ~= s then
					local b3 = self[t.hB]
					self[t.hB] = s
					b3[t.cf]()
				end
				if cK[self] then
					cK[self] = s
				end
				self[t.hE] = s
				self[t.bT] = q
			end)
			self:_updateSnapInfo()
		end
		function cM:resize(da, db)
			if self[t.bT] ~= r then
				return
			end
			local bs = self[t.aM]
			local dc = bs[t.cN].X[t.hj]
			local dd = bs[t.cN].Y[t.hj]
			local dm = dc
			local dn = dc + da
			local dp = dd
			local dq = dd + db
			for dr, ds in pairs(cK) do
				local dt = r
				if dr == self or dm > ds.r + cD or dn < ds.l - cD or dp > ds.b + cD or dq < ds.t - cD then
					dt = q
				end
				if dt then
					if d(ds.t - dq) <= cD then
						db = ds.t - dp
					end
					if d(ds.b - dq) <= cD then
						db = ds.b - dp
					end
					if d(ds.l - dn) <= cD then
						da = ds.l - dm
					end
					if d(ds.r - dn) <= cD then
						da = ds.r - dm
					end
				end
			end
			da = math[t.gY](da, cz, cA)
			db = math[t.gY](db, cB, bn[t.x][t.gX].Y)
			bs.Size = h(0, da, 0, db)
			self[t.hF] = { Width = da, Height = db }
			self:_checkConstraints()
			self:_updateSnapInfo()
			self:updateContentSize()
		end
		function cM:move(du, dv)
			if self[t.bT] ~= r then
				return
			end
			local bs = self[t.aM]
			local dw = bs[t.fu]
			local da = bs.Size.X[t.hj]
			local db = bs.Size.Y[t.hj]
			if du == t.cp then
				du = dw[t.gX].X / 2 - da / 2
			elseif du == t.bv then
				du = 15
			elseif du == t.bw then
				du = dw[t.gX].X - (da + 15)
			end
			if dv == t.cp then
				dv = dw[t.gX].Y / 2 - db / 2
			elseif dv == "top" then
				dv = 0
			elseif dv == t.bt then
				dv = dw[t.gX].Y - db
			end
			local dc = du
			local dd = dv
			if dc < 0 then
				dc = dw[t.gX].X - (da + 15) + dc
			end
			if dd < 0 then
				dd = dw[t.gX].Y - db + dd
			end
			local dm = dc
			local dn = dc + da
			local dp = dd
			local dq = dd + db
			for dr, ds in pairs(cK) do
				local dt = r
				if dr == self or dm > ds.r + cD or dn < ds.l - cD or dp > ds.b + cD or dq < ds.t - cD then
					dt = q
				end
				if dt then
					if d(ds.t - dq) <= cD then
						dd = ds.t - db
					end
					if d(ds.b - dp) <= cD then
						dd = ds.b
					end
					if d(ds.l - dn) <= cD then
						dc = ds.l - da
					end
					if d(ds.r - dm) <= cD then
						dc = ds.r
					end
					if d(ds.t - dp) <= cD then
						dd = ds.t
					end
					if d(ds.b - dq) <= cD then
						dd = ds.b - db
					end
					if d(ds.l - dm) <= cD then
						dc = ds.l
					end
					if d(ds.r - dn) <= cD then
						dc = ds.r - da
					end
				end
			end
			local dx = dw[t.gX].X - da
			local dy = dw[t.gX].Y - db
			dc = math[t.gY](dc, 0, b(dx, 0))
			dd = math[t.gY](dd, 0, b(dy, 0))
			bs[t.cN] = h(0, dc, 0, dd)
			self:_checkConstraints()
			self:_updateSnapInfo()
		end
		function cM:updateContentSize()
			al[t.fp](self[t.hG])
			self[t.hG] = al[t.fo](function()
				local dz = self[t.aM][t.gX].Y
				local dA = dz
				if self[t.bR][t.aY] == r then
					self[t.bP][t.fX] = q
					dA = cC
				else
					self[t.bP][t.fX] = r
					local dB = {}
					local dC = {}
					for J, cV in pairs(self[t.bP]:GetChildren()) do
						local cW = cV:GetAttribute(t.ca .. self._id)
						l[t.fg](dB, cW)
						dC[cW] = cV
					end
					l.sort(dB)
					local b2 = cC
					for J, cW in p(dB) do
						local cV = dC[cW]
						cV[t.cN] = h(0, 0, 0, b2)
						b2 = b2 + cV[t.gX].Y
					end
					dA = b2
					if self[t.bT] == r then
						dA = b(cB, dA)
					end
				end
				self[t.aM][t.fX] = r
				if dz ~= dA then
					if self[t.bT] == r then
						self[t.bP].Size = h(1, 0, 0, dA)
						local bs = self[t.aM]
						if self[t.bR][t.aY] then
							bs.Size = h(0, bs.Size.X[t.hj], 0, cC)
						else
							local da = bs.Size.X[t.hj]
							local db = b(cB, dA)
							if self[t.hF] then
								da = self[t.hF][t.hI]
								db = self[t.hF][t.dm]
							end
							bs.Size = h(0, da, 0, db)
						end
						self:_checkConstraints()
						self:_updateSnapInfo()
						al[t.fo](function()
							self[t.hD]:update()
						end, 10)
					else
						self[t.aM].Size = h(1, 0, 0, dA)
						self[t.bP].Size = h(1, -5, 1, 0)
						local ch = self:_getParentPanel()
						if ch ~= s then
							ch:updateContentSize()
						end
					end
				end
			end, 10)
		end
		function cM:onDestroy(aH)
			return self[t.bV][t.gS]:Connect(aH)
		end
		function cM:destroy()
			self[t.hg]()
			if self[t.bT] == r then
				self[t.hw]()
			end
			if self[t.bU] == r then
				self[t.hy]()
			end
			for aa, b3 in p(self[t.bW]) do
				b3[t.cf]()
			end
			self[t.bW] = {}
			self[t.bV]:Fire()
			cL[self._id] = s
		end
		function cM:_updateActions()
			local dD = {}
			for aa, b3 in p(self[t.bW]) do
				if b3 ~= self[t.hx] and b3 ~= self[t.hC] and b3 ~= self[t.hB] then
					l[t.fg](dD, b3)
				end
			end
			if self[t.hx] ~= s then
				l[t.fg](dD, self[t.hx])
			elseif self[t.hC] ~= s then
				l[t.fg](dD, self[t.hC])
			end
			if self[t.hB] ~= s then
				l[t.fg](dD, self[t.hB])
			end
			self[t.bW] = dD
			local b8 = #self[t.bW] * cG + cH
			for aa, b3 in p(self[t.bW]) do
				b3[t.ce][t.cN] = h(1, -b8 + (aa - 1) * cG, 0, cH)
			end
		end
		function cM:_getParentPanel()
			local bs = self[t.aM][t.fu]
			while bs ~= s and bs ~= bn[t.x] do
				if bs:GetAttribute(t.bX) == r then
					return cL[bs:GetAttribute(t.bY)]
				end
				bs = bs[t.fu]
			end
		end
		function cM:_checkConstraints()
			if self[t.bT] ~= r then
				return
			end
			local bs = self[t.aM]
			local dc = bs[t.cN].X[t.hj]
			local dd = bs[t.cN].Y[t.hj]
			local da = bs.Size.X[t.hj]
			local db = bs.Size.Y[t.hj]
			local dw = bs[t.fu]
			local dx = dw[t.gX].X - da
			local dy = dw[t.gX].Y - db
			dc = math[t.gY](bs[t.cN].X[t.hj], 0, b(dx, 0))
			dd = math[t.gY](bs[t.cN].Y[t.hj], 0, b(dy, 0))
			bs[t.cN] = h(0, dc, 0, dd)
			da = math[t.gY](da, cz, cA)
			local dE = cB
			if self[t.bR][t.aY] then
				dE = cC
			end
			db = math[t.gY](db, dE, bn[t.x][t.gX].Y)
			bs.Size = h(0, da, 0, db)
		end
		function cM:_updateSnapInfo()
			local bs = self[t.aM]
			local da = bs.Size.X[t.hj]
			local db = bs.Size.Y[t.hj]
			local dc = bs[t.cN].X[t.hj]
			local dd = bs[t.cN].Y[t.hj]
			cK[self] = { l = dc, r = dc + da, t = dd, b = dd + db }
		end
		return cM
	end
	D[9] = function()
		local a2 = w
		local as = x
		local G = E(2)
		local c3 = E(4)
		local bo = E(5)
		local aw = E(7)
		local bn = E(6)
		local V = g[t.eX](255, 255, 255)
		local function dF()
			local bw, bD, dG = bo[t.gH]({ [t.cs] = t.ct, [t.cu] = bn[t.z] })
			local bx = bw:WaitForChild(t.aR)
			local dH = bw:WaitForChild(t.aW)
			local bH = k(t.cv)
			bH.Name = t.aY
			bH[t.aY] = g[t.eX](0, 0, 0)
			bH[t.fu] = bw
			local dI = k(t.bE)
			dI.Name = "Hue"
			dI[t.aY] = 0
			dI[t.fu] = bw
			local dJ = k(t.bE)
			dJ.Name = t.cx
			dJ[t.aY] = 0
			dJ[t.fu] = bw
			local dK = k(t.bE)
			dK.Name = t.cy
			dK[t.aY] = 0
			dK[t.fu] = bw
			local dL = k(t.aQ)
			local function dM(P)
				if o(P) == 0 then
					return t.cz
				else
					local W = G[t.fa](P)
					if W == s then
						return t.cz
					else
						return n[t.eV](t.cA, W.R * 255, W.G * 255, W.B * 255)
					end
				end
			end
			local dN, bI, bN, bO, dO = bo[t.gJ]({ [t.cu] = bn[t.O], [t.cB] = dL, [t.cC] = q, [t.aR] = bx })
			bI[t.cN] = h(0, 0, 0, 3)
			bI.Size = h(1, 0, 1, -6)
			bI[t.fu] = bD
			local bK = bI:WaitForChild(t.bc)
			bK[t.cN] = h(0, 0, 0, 0)
			bK.Size = h(1, 0, 1, 0)
			bK[t.gD] = i[t.gD][t.gG]
			local bJ = bI:WaitForChild(t.ba)
			bJ[t.cN] = h(0, 0, 0, 0)
			bJ.Size = h(1, 0, 1, 0)
			bJ[t.gD] = i[t.gD][t.gG]
			local dP = bo[t.gg]()
			dP.Name = t.cD
			dP[t.gh] = bn[t.A]
			dP[t.hu] = bn[t.A]
			dP[t.fT] = 3
			dP[t.cN] = h(0, 0, 0, 0)
			dP.Size = h(0, 122, 0, 102)
			local dQ = bo[t.gg]()
			dQ.Name = "Hue"
			dQ[t.hu] = bn[t.D]
			dQ[t.fT] = 1
			dQ[t.cN] = h(1, -16, 0, 1)
			dQ.Size = h(0, 15, 0, 100)
			dQ[t.fu] = dP
			local dR = bo[t.gg]()
			dR.Name = t.cF
			dR[t.gh] = V
			dR[t.fu] = dQ
			local dS = k(t.cG)
			dS.Name = t.cy
			dS[t.hJ] = r
			dS[t.hb] = 90
			dS[t.hK] = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0) })
			dS[t.cu] = ColorSequence.new({
				ColorSequenceKeypoint.new(0, g[t.eX](255, 0, 0)),
				ColorSequenceKeypoint.new(0.17, g[t.eX](255, 0, 255)),
				ColorSequenceKeypoint.new(0.34, g[t.eX](0, 0, 255)),
				ColorSequenceKeypoint.new(0.5, g[t.eX](0, 255, 255)),
				ColorSequenceKeypoint.new(0.67, g[t.eX](0, 255, 0)),
				ColorSequenceKeypoint.new(0.84, g[t.eX](255, 255, 0)),
				ColorSequenceKeypoint.new(1, g[t.eX](255, 0, 0)),
			})
			dS[t.fu] = dR
			local dT = bo[t.gg]()
			dT.Name = t.cH
			dT[t.gh] = V
			dT[t.hu] = bn[t.D]
			dT[t.fT] = 1
			dT[t.cN] = h(1, -2, 0.1, 0)
			dT.Size = h(0, 4, 0, 2)
			dT[t.fY] = 2
			dT[t.fu] = dQ
			local dU = bo[t.gg]()
			dU.Name = t.cI
			dU[t.gh] = V
			dU[t.hu] = bn[t.D]
			dU[t.fT] = 1
			dU[t.cN] = h(0, 1, 0, 1)
			dU.Size = h(0, 100, 0, 100)
			dU[t.fY] = 2
			dU[t.fu] = dP
			local dV = bo[t.fQ](t.cJ)
			dV.Name = t.cK
			dV[t.gh] = V
			dV[t.hu] = g[t.eX](27, 42, 53)
			dV[t.gi] = i[t.gi][t.gj]
			dV[t.fT] = 1
			dV[t.cN] = h(0, 0, 0, 0)
			dV.Size = h(0, 100, 0, 100)
			dV[t.gb] = V
			dV[t.fu] = dU
			local dW = bo[t.fQ](t.cL)
			dW.Name = t.cy
			dW[t.gh] = V
			dW[t.hu] = g[t.eX](27, 42, 53)
			dW[t.gi] = i[t.gi][t.gj]
			dW[t.fT] = 1
			dW[t.cN] = h(0, 0, 0, 0)
			dW[t.hb] = -90
			dW.Size = h(0, 100, 0, 100)
			dW[t.fY] = 1
			dW[t.gb] = g[t.eX](255, 0, 0)
			dW[t.fu] = dU
			local dX = bo[t.gg]()
			dX.Name = t.cH
			dX[t.gh] = g[t.eX](255, 3, 7)
			dX[t.hu] = V
			dX[t.fT] = 2
			dX[t.cN] = h(0.4, 0, 0.1, 0)
			dX[t.hb] = 45
			dX.Size = h(0, 10, 0, 10)
			dX[t.fY] = 3
			dX[t.fu] = dU
			local H = {}
			local dY = q
			local dZ = q
			local d_ = q
			local e0 = q
			local e1 = q
			local e2 = q
			local e3 = q
			dL[t.aY] = q
			local e4 = q
			local function e5()
				if e4 then
					return
				end
				local e6, e7, e8 = bH[t.aY]:ToHSV()
				local e9 = q
				if math[t.hL](239 * e6 + 0.5) ~= dI[t.aY] then
					e6 = dI[t.aY] / 239
					e9 = r
				end
				if math[t.hL](240 * e7 + 0.5) ~= dK[t.aY] then
					e7 = dK[t.aY] / 240
					e9 = r
				end
				if math[t.hL](240 * e8 + 0.5) ~= dJ[t.aY] then
					e8 = dJ[t.aY] / 240
					e9 = r
				end
				if e9 then
					bH[t.aY] = g[t.hM](e6, e7, e8)
				end
			end
			local function ea()
				local e6, e7, e8 = bH[t.aY]:ToHSV()
				e4 = r
				dI[t.aY] = math[t.hL](239 * e6 + 0.5)
				dK[t.aY] = math[t.hL](240 * e7 + 0.5)
				dJ[t.aY] = math[t.hL](240 * e8 + 0.5)
				e4 = q
				dX[t.cN] = h(e7, -5, 1 - e8, -5)
				dX[t.hu] = G[t.eY](bH[t.aY])
				dX[t.gh] = bH[t.aY]
			end
			local d0 = c3.new(bI, f(122, 102), t.bt, -4)
			dP[t.fu] = d0[t.aM]
			local function eb()
				if e3 or bx[t.aY] then
					d0:hide()
				elseif dY or dZ or d_ or e1 or e0 or e2 then
					d0:show()
				else
					d0:hide()
				end
			end
			local function ec(b5)
				local b1 = b5[t.cN].Y - bn[t.w]
				local c0 = dQ[t.gX].Y
				local bZ = dQ[t.gW].Y
				local ed = (b1 - bZ) / c0
				if ed < 0 then
					ed = 0
				elseif ed > 1 then
					ed = 1
				end
				dI[t.aY] = math[t.hL](239 * (1 - ed) + 0.5)
			end
			local function ee(b5)
				local b0 = b5[t.cN].X
				local bY = dU[t.gW].X
				local b_ = dU[t.gX].X
				local ef = (b0 - bY) / b_
				if ef < 0 then
					ef = 0
				elseif ef > 1 then
					ef = 1
				end
				dK[t.aY] = math[t.hL](240 * ef + 0.5)
				local b1 = b5[t.cN].Y - bn[t.w]
				local bZ = dU[t.gW].Y
				local c0 = dU[t.gX].Y
				local eg = (b1 - bZ) / c0
				if eg < 0 then
					eg = 0
				elseif eg > 1 then
					eg = 1
				end
				dJ[t.aY] = math[t.hL](240 * (1 - eg) + 0.5)
			end
			local function eh()
				local W = bH[t.aY]
				bJ[t.gv] = G[t.eY](W)
				bK[t.gv] = bJ[t.gv]
				dH[t.gh] = W
				bI[t.gh] = W
			end
			l[t.fg](
				H,
				bH[t.gI]:Connect(function()
					spawn(function()
						local W = bH[t.aY]
						dN[t.aY] = n[t.eV](t.cA, W.R * 255, W.G * 255, W.B * 255)
					end)
					eh()
					ea()
				end)
			)
			l[t.fg](
				H,
				dN[t.gI]:Connect(function()
					local W = G[t.fa](dN[t.aY])
					if W == s then
						W = g[t.eX](0, 0, 0)
					end
					bH[t.aY] = W
				end)
			)
			l[t.fg](
				H,
				bN:Connect(function()
					e3 = r
					eb()
				end)
			)
			l[t.fg](
				H,
				bO:Connect(function()
					e3 = q
					eh()
					eb()
				end)
			)
			l[t.fg](
				H,
				dI[t.gI]:Connect(function()
					local e6 = dI[t.aY]
					if e6 == 0 then
						e6 = 1
					end
					dT[t.cN] = h(1, -2, 1 - e6 / 239, -1)
					dW[t.gb] = g[t.hM](dI[t.aY] / 239, 1, 1)
					e5()
				end)
			)
			l[t.fg](
				H,
				dK[t.gI]:Connect(function()
					e5()
				end)
			)
			l[t.fg](
				H,
				dJ[t.gI]:Connect(function()
					e5()
				end)
			)
			l[t.fg](
				H,
				aw[t.fI](bI, function(bS)
					dY = bS
					eb()
				end)
			)
			l[t.fg](
				H,
				aw[t.fI](d0[t.aM], function(bS)
					dZ = bS
					eb()
				end)
			)
			l[t.fg](
				H,
				aw[t.fI](dU, function(bS)
					e1 = bS
					eb()
				end)
			)
			l[t.fg](
				H,
				aw[t.fI](dQ, function(bS)
					d_ = bS
					eb()
				end)
			)
			l[t.fg](
				H,
				aw[t.fN](dU, function(aG, bl, b2, be)
					if aG == t.aE then
						e2 = r
						eb()
					elseif aG == "end" then
						e2 = q
						eb()
					elseif aG == t.aD then
						ee({ [t.cN] = b2 })
					end
				end)
			)
			l[t.fg](
				H,
				aw[t.fN](dQ, function(aG, bl, b2, be)
					if aG == t.aE then
						e0 = r
						eb()
					elseif aG == "end" then
						e0 = q
						eb()
					elseif aG == t.aD then
						ec({ [t.cN] = b2 })
					end
				end)
			)
			return bw, G[t.eQ](H, dG, dO, function()
				d0:destroy()
			end)
		end
		local function ei(ej, ek, el, em)
			local bs, en = dF()
			bs[t.fu] = ej[t.bP]
			local eo = bs:WaitForChild(t.aY)
			local ep = bs:WaitForChild(t.aR)
			local eq
			local er
			local es = { [t.ce] = bs, [t.cP] = bs[t.gX].Y }
			eo[t.gI]:Connect(function()
				if not ep[t.aY] then
					if em then
						ek[el][t.aY] = eo[t.aY]
					else
						ek[el] = eo[t.aY]
					end
				end
				if eq ~= s then
					eq(es[t.hN]())
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(P)
				eo[t.aY] = P
				return es
			end
			es[t.hN] = function()
				if em then
					return ek[el][t.aY]
				else
					return ek[el]
				end
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				if er ~= s then
					er:Disconnect()
				end
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es[t.hS] = function()
				if er ~= s then
					return
				end
				if em then
					er = ek[el][t.gI]:Connect(function(P)
						es[t.hP](ek[el][t.aY])
					end)
				elseif ek["IsA"] ~= s then
					er = ek:GetPropertyChangedSignal(el):Connect(function(P)
						es[t.hP](ek[el])
					end)
				else
					local eu = ek[el]
					er = a2[t.fb]:Connect(function()
						if ek[el] ~= eu then
							eu = ek[el]
							es[t.hP](ek[el])
						end
					end)
				end
				return es
			end
			es[t.hP](es[t.hN]())
			return es
		end
		return ei
	end
	D[10] = function()
		local a2 = w
		local ev = B
		local as = x
		local G = E(2)
		local c3 = E(4)
		local bo = E(5)
		local aw = E(7)
		local ce = E(8)
		local bn = E(6)
		local function dF()
			local bw, bD, dG = bo[t.gH]({ [t.cs] = t.cS, [t.cu] = bn[t.N] })
			local ew = k(t.bE)
			ew.Name = t.cT
			ew[t.aY] = 0
			ew[t.fu] = bw
			local ex = k(t.aT)
			ex.Name = t.cU
			ex[t.fu] = bw
			local ey = bo[t.gg]()
			ey.Name = t.cV
			ey[t.fS] = 1
			ey[t.cN] = h(0, 0, 0, 3)
			ey.Size = h(1, 0, 1, -6)
			ey[t.fu] = bD
			local ez = ey[t.gX].Y
			local d0 = c3.new(ey, f(122, ez), t.bt, -ez)
			local eA = bo[t.gg]()
			eA.Name = t.cW
			eA[t.fS] = 1
			eA[t.fu] = d0[t.aM]
			d0[t.aM][t.hl] = r
			local eB = ce.new(d0[t.aM], eA, 0)
			local eC = k(t.cX)
			eC.Name = t.cY
			eC[t.fZ] = r
			eC[t.hT] = i[t.hT][t.hU]
			eC[t.hV] = i[t.hV].Left
			eC[t.hW] = i[t.hW][t.hm]
			eC[t.hX] = i[t.hX].Top
			eC[t.fu] = eA
			local eD = bo[t.gg]()
			eD.Name = t.cZ
			eD[t.gh] = bn[t.R]
			eD[t.fS] = 0
			eD.Size = h(1, 0, 0, ez)
			eD[t.fX] = r
			eD[t.fu] = ey
			local eE = bo[t.go]()
			eE.Name = t.aU
			eE[t.cN] = h(0, 2, 0, 0)
			eE.Size = h(1, -4, 1, 0)
			eE.Text = t.da
			eE[t.gv] = bn[t.N]
			eE[t.fu] = eD
			local eF
			local H = {}
			local eG = {}
			local eH = 0
			local eI = q
			local eJ = q
			local eK = q
			local eL = 1
			local function eb()
				if eK and (eJ or eI) then
					d0:resize(f(ey[t.gX].X, c(ez * eL, ez * 4)))
					eB:update()
					d0:show()
				else
					d0:hide()
				end
			end
			l[t.fg](
				H,
				aw[t.fH](eA, function(bj)
					eI = bj
					if bj then
						eK = r
					end
					eb()
				end)
			)
			l[t.fg](
				H,
				aw[t.fI](ey, function(bS)
					eJ = bS
					if bS then
						eK = r
					end
					eb()
				end)
			)
			local function eM(eN, eO)
				if ew[t.aY] == eN:GetAttribute(t.db) then
					eO[t.gv] = bn[t.R]
					eN[t.gh] = bn[t.N]
				else
					eO[t.gv] = bn[t.R]
					eN[t.gh] = bn[t.U]
				end
			end
			l[t.fg](
				H,
				ew[t.gI]:connect(function()
					if eF ~= s then
						for eP, bu in pairs(eF) do
							if ew[t.aY] == eP then
								eE.Text = bu
								break
							end
						end
					end
					for J, eN in pairs(eA:GetChildren()) do
						if eN:IsA(t.aM) then
							eM(eN, eN:WaitForChild(t.aU))
						end
					end
					eb()
				end)
			)
			l[t.fg](
				H,
				ex[t.gI]:Connect(function()
					eF = ev:JSONDecode(ex[t.aY])
					for J, K in p(eG) do
						K:Disconnect()
					end
					l[t.eR](eG)
					eL = 0
					for eP, bu in pairs(eF) do
						local eN = eD:Clone()
						eN.Name = t.dc .. eP
						eN[t.hm] = eP
						eN[t.gh] = bn[t.U]
						eN:SetAttribute(t.db, eP)
						local eO = eN:WaitForChild(t.aU)
						eO.Text = bu
						eO[t.gv] = bn[t.R]
						eN[t.fu] = eA
						eL = eL + 1
						if ew[t.aY] == eP then
							eE.Text = bu
						end
						l[t.fg](
							eG,
							aw[t.fI](eN, function(bS)
								if bS then
									eO[t.gv] = bn[t.S]
									eN[t.gh] = bn[t.V]
								else
									eM(eN, eO)
								end
							end)
						)
						l[t.fg](
							eG,
							aw[t.fL](eN, function()
								ew[t.aY] = eP
								eE.Text = bu
								eK = q
								eb()
								return q
							end)
						)
					end
					eA.Size = h(1, 0, 0, ez * eL)
					eb()
				end)
			)
			return bw, G[t.eQ](H, G[t.eQ](eG), function()
				d0:destroy()
				eB:destroy()
			end)
		end
		local function eQ(eR)
			if type(eR) ~= t.dd then
				return s, t.de .. type(eR)
			end
			local a9 = 0
			for eS, eT in pairs(eR) do
				if type(eS) ~= t.p then
					return q
				else
					a9 = a9 + 1
				end
			end
			for aa = 1, a9 do
				if not eR[aa] and type(eR[aa]) ~= "nil" then
					return q
				end
			end
			return r
		end
		local function eU(ej, ek, el, eV)
			local bs, en = dF()
			bs[t.fu] = ej[t.bP]
			local eW = bs:WaitForChild(t.cU)
			local eX = bs:WaitForChild(t.cT)
			local ep = bs:WaitForChild(t.aR)
			local eq
			local er
			local eY = {}
			local eZ = {}
			local e_ = 1
			local f0 = typeof(ek[el]) == t.dg or typeof(eV) == t.dh
			local f1
			if f0 then
				if typeof(ek[el]) == t.dg then
					f1 = ek[el][t.hY]:GetEnumItems()
				else
					f1 = eV:GetEnumItems()
				end
			end
			local es = { frame = bs, height = bs[t.gX].Y }
			local function f2()
				eY = {}
				if f0 then
					local f3 = typeof(ek[el]) == t.p
					for eP, f4 in p(f1) do
						l[t.fg](eY, f4)
						l[t.fg](eZ, f4.Name)
						if f3 then
							if ek[el] == eP - 1 then
								e_ = eP
							end
						else
							if ek[el] == f4 then
								e_ = eP
							end
						end
					end
				elseif eQ(eV) then
					local eP = 1
					local f5 = typeof(ek[el]) == t.p
					for eP, P in p(eV) do
						if type(P) == t.di then
							l[t.fg](eY, P)
							l[t.fg](eZ, P)
							if f5 then
								if ek[el] == eP then
									e_ = eP
								end
							else
								if ek[el] == P then
									e_ = eP
								end
							end
							eP = eP + 1
						end
					end
				else
					local eP = 1
					for bt, P in pairs(eV) do
						if type(bt) == t.di then
							l[t.fg](eY, bt)
							l[t.fg](eZ, P)
							if ek[el] == bt then
								e_ = eP
							end
							eP = eP + 1
						end
					end
				end
				eW[t.aY] = ev:JSONEncode(eZ)
			end
			eX[t.gI]:connect(function()
				if not ep[t.aY] then
					ek[el] = eY[eX[t.aY]]
				end
				if eq ~= s then
					eq(eY[eX[t.aY]], eZ[eX[t.aY]])
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(bt)
				local eP = s
				for aa, P in p(eY) do
					if bt == P then
						eP = aa
						break
					end
				end
				if eP == s then
					return
				end
				eX[t.aY] = eP
				return es
			end
			es[t.hN] = function()
				return eX[t.aY]
			end
			es[t.hZ] = function(f6)
				if f0 == q then
					eV = f6
				end
				return es
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				if er ~= s then
					er:Disconnect()
				end
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es[t.hS] = function()
				if er ~= s then
					return
				end
				if ek["IsA"] ~= s then
					er = ek:GetPropertyChangedSignal(el):Connect(function(P)
						es[t.hP](ek[el])
					end)
				else
					local eu = ek[el]
					er = a2[t.fb]:Connect(function()
						if ek[el] ~= eu then
							eu = ek[el]
							es[t.hP](eu)
						end
					end)
				end
				return es
			end
			f2()
			eX[t.aY] = e_
			return es
		end
		return eU
	end
	D[11] = function()
		local a2 = w
		local G = E(2)
		local bo = E(5)
		local bn = E(6)
		local function dF(f7)
			local f8 = 30
			if f7 then
				f8 = 120
			end
			local bw, bD, dG = bo[t.gH]({ [t.cs] = t.dl, [t.cu] = bn[t.N], [t.dm] = f8 })
			local f9 = bo[t.gg]()
			f9.Name = t.dn
			f9[t.fS] = 1
			f9[t.cN] = h(0, 0, 0, 3)
			f9.Size = h(1, 0, 1, -6)
			f9[t.fu] = bD
			local bH, bI, bN, bO, dO = bo[t.gJ]({ [t.cu] = bn[t.N], [t._do] = f7, [t.aR] = bw:WaitForChild(t.aR) })
			bH[t.fu] = bw
			bI[t.fu] = f9
			local H = {}
			return bw, G[t.eQ](H, dG, dO)
		end
		local function fa(ej, ek, el, f7, fb)
			local bs, en = dF(f7)
			bs[t.fu] = ej[t.bP]
			local ep = bs:WaitForChild(t.aR)
			local fc = bs:WaitForChild(t.aY)
			local eq
			local er
			local es = { frame = bs, height = bs[t.gX].Y }
			fc[t.gI]:connect(function()
				if not ep[t.aY] then
					if fb then
						ek[el][t.aY] = fc[t.aY]
					else
						ek[el] = fc[t.aY]
					end
				end
				if eq ~= s then
					eq(es[t.hN]())
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(P)
				fc[t.aY] = P
				return es
			end
			es[t.hN] = function()
				if fb then
					return ek[el][t.aY]
				else
					return ek[el]
				end
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				if er ~= s then
					er:Disconnect()
				end
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es[t.hS] = function()
				if er ~= s then
					return
				end
				if fb then
					er = ek[el][t.gI]:Connect(function(P)
						es[t.hP](ek[el][t.aY])
					end)
				elseif ek["IsA"] ~= s then
					er = ek:GetPropertyChangedSignal(el):Connect(function(P)
						es[t.hP](ek[el])
					end)
				else
					local eu = ek[el]
					er = a2[t.fb]:Connect(function(fd)
						if ek[el] ~= eu then
							eu = ek[el]
							es[t.hP](ek[el])
						end
					end)
				end
				return es
			end
			es[t.hP](es[t.hN]())
			return es
		end
		return fa
	end
	D[12] = function()
		local a2 = w
		local as = x
		local G = E(2)
		local bo = E(5)
		local aw = E(7)
		local bn = E(6)
		local function dF()
			local bw, bD, dG = bo[t.gH]({ [t.cs] = t.dr, [t.cu] = bn[t.I] })
			local bx = bw:WaitForChild(t.aR)
			local bH = k(t.aQ)
			bH.Name = t.aY
			bH[t.aY] = q
			bH[t.fu] = bw
			local fe = bo[t.gg]()
			fe.Name = t.ds
			fe[t.gh] = bn[t.K]
			fe[t.fS] = 0
			fe[t.cN] = h(0, 0, 0, 3)
			fe.Size = h(0, 23, 1, -6)
			fe[t.fu] = bD
			local bq = bo[t.fQ](bn[t.ab])
			bq.Name = t.dt
			bq[t.gb] = bn[t.M]
			bq[t.fu] = fe
			local H = {}
			local bM = q
			local function ff()
				if bH[t.aY] then
					if bM and not bx[t.aY] then
						fe[t.gh] = bn[t.P]
					else
						fe[t.gh] = bn[t.O]
					end
				elseif bM and not bx[t.aY] then
					fe[t.gh] = bn[t.T]
				else
					fe[t.gh] = bn[t.R]
				end
			end
			l[t.fg](
				H,
				bH[t.gI]:connect(function()
					bq[t.fX] = bH[t.aY]
					ff()
				end)
			)
			l[t.fg](
				H,
				aw[t.fI](bw, function(bS)
					bM = bS
					ff()
				end)
			)
			l[t.fg](
				H,
				aw[t.fL](bw, function(cX, b5)
					bH[t.aY] = not bH[t.aY]
					return q
				end)
			)
			return bw, G[t.eQ](H, dG)
		end
		local fg = function(ej, ek, el, fh)
			local bs, en = dF()
			bs[t.fu] = ej[t.bP]
			local fi = bs:WaitForChild(t.aY)
			local ep = bs:WaitForChild(t.aR)
			local eq
			local er
			local es = { [t.ce] = bs, [t.cP] = bs[t.gX].Y }
			fi[t.gI]:connect(function()
				if not ep[t.aY] then
					if fh then
						ek[el][t.aY] = fi[t.aY]
					else
						ek[el] = fi[t.aY]
					end
				end
				if eq ~= s then
					eq(es[t.hN]())
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(P)
				if P == r or P == q then
					fi[t.aY] = P
				end
				return es
			end
			es[t.hN] = function()
				if fh then
					return ek[el][t.aY]
				else
					return ek[el]
				end
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				if er ~= s then
					er:Disconnect()
				end
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es[t.hS] = function()
				if er ~= s then
					return
				end
				if fh then
					er = ek[el][t.gI]:Connect(function(P)
						es[t.hP](ek[el][t.aY])
					end)
				elseif ek["IsA"] ~= s then
					er = ek:GetPropertyChangedSignal(el):Connect(function(P)
						es[t.hP](ek[el])
					end)
				else
					local eu = ek[el]
					er = a2[t.fb]:Connect(function()
						if ek[el] ~= eu then
							eu = ek[el]
							es[t.hP](ek[el])
						end
					end)
				end
				return es
			end
			es[t.hP](es[t.hN]())
			return es
		end
		return fg
	end
	D[13] = function()
		local bo = E(5)
		local bn = E(6)
		local fj = function(ej, fk, bv)
			if bv == s then
				bv = {}
			end
			local bs, bD, en = bo[t.gH]({ [t.cs] = fk, [t.cu] = bv[t.hr] or bn[t.W], [t.dm] = bv[t.cP] })
			bs[t.fu] = ej[t.bP]
			bv[t.ce][t.fu] = bD
			bv[t.ce][t.cN] = h(0, 0, 0, 3)
			bv[t.ce].Size = h(1, 0, 1, -6)
			local es = { [t.ce] = bs, [t.cP] = bs[t.gX].Y }
			if bv[t.ia] ~= s then
				for fl, ae in pairs(bv[t.ia]) do
					es[fl] = ae
				end
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
				if type(bv[t.ib]) == t.e then
					return bv[t.ib]()
				end
			end
			return es
		end
		return fj
	end
	D[14] = function()
		local a2 = w
		local G = E(2)
		local bo = E(5)
		local bn = E(6)
		local function dF()
			local bw, bD, dG = bo[t.gH]({ [t.cs] = t.dx, [t.cu] = bn[t.O] })
			local bx = bw:WaitForChild(t.aR)
			local fm = k(t.be)
			fm.Name = t.dy
			local bT = k(t.be)
			bT.Name = "Min"
			bT[t.aY] = -a
			local bU = k(t.be)
			bU.Name = "Max"
			bU[t.aY] = a
			local fn = k(t.be)
			fn.Name = t.dB
			fn[t.aY] = G[t.eN]
			local fo = k(t.bE)
			fo.Name = t.dC
			fo[t.aY] = G[t.eO]
			fm[t.fu] = bw
			bT[t.fu] = bw
			bU[t.fu] = bw
			fn[t.fu] = bw
			fo[t.fu] = bw
			local dM = G[t.eU](fo)
			local bH, bI, bN, bO, dO = bo[t.gJ]({
				[t.cu] = bn[t.O],
				[t.dD] = dM,
				[t.aR] = bx,
				[t.dE] = function(bF, P)
					if o(bF) == 0 then
						return "0"
					else
						local bF = m(bF)
						if bF == s then
							return P[t.aY]
						else
							return dM(bF)
						end
					end
				end,
			})
			local f9 = bo[t.gg]()
			f9.Name = t.dn
			f9[t.fS] = 1
			f9[t.cN] = h(0, 0, 0, 3)
			f9.Size = h(1, 0, 1, -6)
			f9[t.fu] = bD
			bI[t.fu] = f9
			bH[t.fu] = bw
			local H = {}
			l[t.fg](
				H,
				fn[t.gI]:connect(function()
					fo[t.aY] = G[t.eS](fn[t.aY])
					if bH[t.aY] ~= s then
						bH[t.aY] = "0" .. bH[t.aY]
					end
				end)
			)
			l[t.fg](
				H,
				fm[t.gI]:connect(function()
					local P = math[t.gY](fm[t.aY], bT[t.aY], bU[t.aY])
					local fd = fn[t.aY]
					if P % fd ~= 0 then
						P = math[t.eZ](P / fd) * fd
					end
					bH[t.aY] = dM(tostring(P))
				end)
			)
			return bw, G[t.eQ](H, dG, dO)
		end
		local function fp(ej, ek, el, fq, fr, fd, fs)
			local bs, en = dF()
			bs[t.fu] = ej[t.bP]
			local ft = bs:WaitForChild("Min")
			local fu = bs:WaitForChild("Max")
			local fv = bs:WaitForChild(t.dB)
			local fc = bs:WaitForChild(t.aY)
			local fw = bs:WaitForChild(t.dy)
			local ep = bs:WaitForChild(t.aR)
			local eq
			local er
			local es = { frame = bs, height = bs[t.gX].Y }
			fc[t.gI]:connect(function()
				if not ep[t.aY] then
					if fs then
						ek[el][t.aY] = m(fc[t.aY])
					else
						ek[el] = m(fc[t.aY])
					end
				end
				if eq ~= s then
					eq(es[t.hN]())
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(P)
				fw[t.aY] = P
				return es
			end
			es[t.hN] = function()
				if fs then
					return ek[el][t.aY]
				else
					return ek[el]
				end
			end
			es.min = function(fq)
				ft[t.aY] = fq
				return es
			end
			es.max = function(fr)
				fu[t.aY] = fr
				return es
			end
			es.step = function(fd)
				fv[t.aY] = fd
				return es
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				if er ~= s then
					er:Disconnect()
				end
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es[t.hS] = function()
				if er ~= s then
					return
				end
				if fs then
					er = ek[el][t.gI]:Connect(function(P)
						es[t.hP](ek[el][t.aY])
					end)
				elseif ek["IsA"] ~= s then
					er = ek:GetPropertyChangedSignal(el):Connect(function(P)
						es[t.hP](ek[el])
					end)
				else
					local eu = ek[el]
					er = a2[t.fb]:Connect(function()
						if ek[el] ~= eu then
							eu = ek[el]
							es[t.hP](eu)
						end
					end)
				end
				return es
			end
			es[t.hP](es[t.hN]())
			if fq ~= s then
				ft[t.aY] = fq
			end
			if fr ~= s then
				fu[t.aY] = fr
			end
			if fd ~= s then
				fv[t.aY] = fd
			end
			return es
		end
		return fp
	end
	D[15] = function()
		local as = x
		local G = E(2)
		local bo = E(5)
		local aw = E(7)
		local bn = E(6)
		local function dF()
			local bw, bD, dG = bo[t.gH]({ [t.cs] = t.dL, [t.cu] = bn[t.Q] })
			local fx = k(t.bd)
			fx.Name = t.at
			fx[t.fu] = bw
			local bA = bw:WaitForChild(t.aO)
			bA.Size = h(1, -10, 1, -1)
			bw:WaitForChild(t.aX)[t.fu] = s
			local H = {}
			l[t.fg](
				H,
				aw[t.fL](bw, function()
					fx:Fire()
					return q
				end)
			)
			return bw, G[t.eQ](H, dG)
		end
		local function fy(ej, ek, el, bF)
			local bs, en = dF()
			bs[t.fu] = ej[t.bP]
			local fz = bs:WaitForChild(t.at)
			local fA = bs:WaitForChild(t.aU)
			local ep = bs:WaitForChild(t.aR)
			local eq
			local es = { [t.ce] = bs, [t.cP] = bs[t.gX].Y }
			fz[t.gS]:connect(function()
				if not ep[t.aY] then
					if eq ~= s then
						eq()
					end
					es[t.hN]()(ek)
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(P)
				if not ep[t.aY] then
					ek[el] = P
				end
				return es
			end
			es[t.hN] = function()
				return ek[el]
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es.name = function(fk)
				fA[t.aY] = fk
				return es
			end
			if bF == s or o(bF) == 0 then
				fA[t.aY] = el
			else
				fA[t.aY] = bF
			end
			return es
		end
		return fy
	end
	D[16] = function()
		local a2 = w
		local as = x
		local G = E(2)
		local bo = E(5)
		local bn = E(6)
		local function dF()
			local bw, bD, fB = bo[t.gH]({ [t.cs] = t.dN, [t.cu] = bn[t.O] })
			local bx = bw:WaitForChild(t.aR)
			local fm = k(t.be)
			fm.Name = t.dy
			fm[t.fu] = bw
			local fn = k(t.be)
			fn.Name = t.dB
			fn[t.aY] = G[t.eN]
			fn[t.fu] = bw
			local fo = k(t.bE)
			fo.Name = t.dC
			fo[t.aY] = G[t.eO]
			fo[t.fu] = bw
			local dM = G[t.eU](fo)
			local f9 = bo[t.gg]()
			f9.Name = t.dn
			f9[t.fS] = 1
			f9[t.cN] = h(0.66, 3, 0, 3)
			f9.Size = h(0.33, -2, 1, -6)
			f9[t.fu] = bD
			local fC = k(t.aQ)
			local dN, bI, fD, fE, fF = bo[t.gJ]({
				[t.cu] = bn[t.O],
				[t.dD] = dM,
				[t.aR] = bx,
				[t.dE] = function(bF, P)
					if o(bF) == 0 then
						return "0"
					else
						local bF = m(bF)
						if bF == s then
							return P[t.aY]
						else
							return dM(bF)
						end
					end
				end,
			})
			bI[t.fu] = f9
			local fG = bo[t.gg]()
			fG[t.fS] = 1
			fG[t.cN] = h(0, 0, 0, 3)
			fG.Size = h(0.66, 0, 1, -6)
			fG[t.fu] = bD
			local fH, fI, bT, bU, bV, fJ, fK, fL = bo[t.gT]({ [t.aR] = bx })
			fH[t.fu] = fG
			local H = {}
			local fM = q
			l[t.fg](
				H,
				fD:Connect(function()
					fM = r
				end)
			)
			l[t.fg](
				H,
				fE:Connect(function()
					fM = q
				end)
			)
			l[t.fg](
				H,
				fn[t.gI]:connect(function()
					fo[t.aY] = G[t.eS](fn[t.aY])
					if dN[t.aY] ~= s then
						dN[t.aY] = "0" .. dN[t.aY]
					end
				end)
			)
			l[t.fg](
				H,
				fI[t.gI]:connect(function()
					dN[t.aY] = tostring(fI[t.aY])
				end)
			)
			l[t.fg](
				H,
				dN[t.gI]:connect(function()
					if fM then
						fI[t.aY] = m(dN[t.aY])
					end
				end)
			)
			l[t.fg](
				H,
				fm[t.gI]:connect(function()
					local P = math[t.gY](fm[t.aY], bT[t.aY], bU[t.aY])
					if P % fn[t.aY] ~= 0 then
						P = math[t.eZ](P / fn[t.aY]) * fn[t.aY]
					end
					fI[t.aY] = P
				end)
			)
			return bw, fI, fm, bT, bU, fn, G[t.eQ](H, fB, fF, fL)
		end
		local function fN(ej, ek, el, fq, fr, fd, fs)
			local bs, fO, fw, ft, fu, fv, en = dF()
			bs[t.fu] = ej[t.bP]
			local ep = bs:WaitForChild(t.aR)
			local eq
			local er
			local es = { frame = bs, height = bs[t.gX].Y }
			fO[t.gI]:connect(function()
				if not ep[t.aY] then
					if fs then
						ek[el][t.aY] = fO[t.aY]
					else
						ek[el] = fO[t.aY]
					end
				end
				if eq ~= s then
					eq(es[t.hN]())
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(P)
				fw[t.aY] = P
				return es
			end
			es[t.hN] = function()
				if fs then
					return ek[el][t.aY]
				else
					return ek[el]
				end
			end
			es.min = function(fq)
				ft[t.aY] = fq
				return es
			end
			es.max = function(fr)
				fu[t.aY] = fr
				return es
			end
			es.step = function(fd)
				fv[t.aY] = fd
				return es
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				if er ~= s then
					er:Disconnect()
				end
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es[t.hS] = function()
				if er ~= s then
					return
				end
				if fs then
					er = ek[el][t.gI]:Connect(function(P)
						es[t.hP](ek[el][t.aY])
					end)
				elseif ek["IsA"] ~= s then
					er = ek:GetPropertyChangedSignal(el):Connect(function(P)
						es[t.hP](ek[el])
					end)
				else
					local eu = ek[el]
					er = a2[t.fb]:Connect(function(fd)
						if ek[el] ~= eu then
							eu = ek[el]
							es[t.hP](ek[el])
						end
					end)
				end
				return es
			end
			es[t.hP](es[t.hN]())
			if fq ~= s then
				ft[t.aY] = fq
			end
			if fr ~= s then
				fu[t.aY] = fr
			end
			if fd ~= s then
				fv[t.aY] = fd
			end
			return es
		end
		return fN
	end
	D[17] = function()
		local a2 = w
		local G = E(2)
		local bo = E(5)
		local bn = E(6)
		local function dF()
			local bw, bD, dG = bo[t.gH]({ [t.cs] = t.dS, [t.cu] = bn[t.O], [t.dm] = 50 })
			local bH = k(t.dT)
			bH.Name = t.aY
			bH[t.aY] = e(0, 0, 0)
			bH[t.fu] = bw
			local fm = k(t.dT)
			fm.Name = t.dy
			fm[t.aY] = e(0, 0, 0)
			fm[t.fu] = bw
			local bT = k(t.dT)
			bT.Name = "Min"
			bT[t.aY] = e(-a, -a, -a)
			bT[t.fu] = bw
			local bU = k(t.dT)
			bU.Name = "Max"
			bU[t.aY] = e(a, a, a)
			bU[t.fu] = bw
			local fn = k(t.dT)
			fn.Name = t.dB
			fn[t.aY] = e(G[t.eN], G[t.eN], G[t.eN])
			fn[t.fu] = bw
			local fo = k(t.dT)
			fo.Name = t.dC
			fo[t.aY] = e(G[t.eO], G[t.eO], G[t.eO])
			fo[t.fu] = bw
			local function fP(fQ, b2)
				local H = {}
				local f9 = bo[t.gg]()
				f9.Name = fQ
				f9[t.fS] = 1
				f9[t.cN] = b2
				f9.Size = h(0.333, 0, 1, -28)
				f9[t.fu] = bD
				local cS = bo[t.go]()
				cS[t.cN] = h(0, 0, 1, 0)
				cS.Text = fQ:lower()
				cS[t.gv] = bn[t.V]
				cS[t.gD] = i[t.gD][t.gG]
				cS[t.fu] = f9
				local fR = k(t.bE)
				fR.Name = t.dC
				fR[t.aY] = G[t.eO]
				local dM = G[t.eU](fR)
				local dN, bI, fD, fE, fF = bo[t.gJ]({
					[t.cu] = bn[t.O],
					[t.dD] = dM,
					[t.aR] = bw:WaitForChild(t.aR),
					[t.dE] = function(bF, P)
						if o(bF) == 0 then
							return "0"
						else
							local bF = m(bF)
							if bF == s then
								return P[t.aY]
							else
								return dM(bF)
							end
						end
					end,
				})
				bI[t.fu] = f9
				l[t.fg](
					H,
					fo[t.gI]:Connect(function()
						fR[t.aY] = fo[t.aY][fQ]
					end)
				)
				return dN, dM, G[t.eQ](H, fF)
			end
			local H = {}
			local fS = {}
			for aa, fQ in p(G.AXES) do
				local ac = (aa - 1) * 0.333
				local fT = (aa - 1) * 2
				local dN, dM, dO = fP(fQ, h(ac, fT, 0, 3))
				fS[fQ] = { TextValue = dN, RenderText = dM, Disconnect = dO }
				l[t.fg](
					H,
					dN[t.gI]:connect(function()
						local P = bH[t.aY]
						local fU = { X = P.X, Y = P.Y, Z = P.Z }
						fU[fQ] = m(dN[t.aY])
						bH[t.aY] = e(fU.X, fU.Y, fU.Z)
					end)
				)
			end
			l[t.fg](
				H,
				fn[t.gI]:connect(function()
					fo[t.aY] = e(G[t.eS](fn[t.aY].X), G[t.eS](fn[t.aY].Y), G[t.eS](fn[t.aY].Z))
					for J, fQ in p(G.AXES) do
						local dN = fS[fQ][t.eh]
						local fV = dN[t.aY]
						if fV == s then
							fV = ""
						end
						dN[t.aY] = "0" .. fV
					end
				end)
			)
			l[t.fg](
				H,
				fm[t.gI]:connect(function()
					for J, fQ in p(G.AXES) do
						local P = math[t.gY](fm[t.aY][fQ], bT[t.aY][fQ], bU[t.aY][fQ])
						local fd = fn[t.aY][fQ]
						if P % fd ~= 0 then
							P = math[t.eZ](P / fd) * fd
						end
						fS[fQ][t.eh][t.aY] = fS[fQ][t.el](tostring(P))
					end
				end)
			)
			return bw, G[t.eQ](H, dG, fS.X[t.em], fS.Y[t.em], fS.Z[t.em])
		end
		local function fW(ej, ek, el, fq, fr, fd, fX)
			local bs, en = dF()
			bs[t.fu] = ej[t.bP]
			local ft = bs:WaitForChild("Min")
			local fu = bs:WaitForChild("Max")
			local fv = bs:WaitForChild(t.dB)
			local fY = bs:WaitForChild(t.aY)
			local fw = bs:WaitForChild(t.dy)
			local ep = bs:WaitForChild(t.aR)
			local eq
			local er
			local es = { frame = bs, height = bs[t.gX].Y }
			fY[t.gI]:connect(function()
				if not ep[t.aY] then
					if fX then
						ek[el][t.aY] = fY[t.aY]
					else
						ek[el] = fY[t.aY]
					end
				end
				if eq ~= s then
					eq(es[t.hN]())
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(P)
				if typeof(P) == t.p then
					P = e(P, P, P)
				end
				fw[t.aY] = P
				return es
			end
			es[t.hN] = function()
				if fX then
					return ek[el][t.aY]
				else
					return ek[el]
				end
			end
			es.min = function(fq)
				if typeof(fq) == t.p then
					fq = e(fq, fq, fq)
				end
				ft[t.aY] = fq
				return es
			end
			es.max = function(fr)
				if typeof(fr) == t.p then
					fr = e(fr, fr, fr)
				end
				fu[t.aY] = fr
				return es
			end
			es.step = function(fd)
				if typeof(fd) == t.p then
					fd = e(fd, fd, fd)
				end
				fv[t.aY] = fd
				return es
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				if er ~= s then
					er:Disconnect()
				end
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es[t.hS] = function()
				if er ~= s then
					return
				end
				if fX then
					er = ek[el][t.gI]:Connect(function(P)
						es[t.hP](ek[el][t.aY])
					end)
				else
					local fZ = ek[el].X
					local f_ = ek[el].Y
					local g0 = ek[el].Z
					er = a2[t.fb]:Connect(function(fd)
						local P = ek[el]
						if P.X ~= fZ or P.Y ~= f_ or P.Z ~= g0 then
							fZ = P.X
							f_ = P.Y
							g0 = P.Z
							es[t.hP](ek[el])
						end
					end)
				end
				return es
			end
			es[t.hP](es[t.hN]())
			if fq ~= s then
				if typeof(fq) == t.p then
					fq = e(fq, fq, fq)
				end
				ft[t.aY] = fq
			end
			if fr ~= s then
				if typeof(fr) == t.p then
					fr = e(fr, fr, fr)
				end
				fu[t.aY] = fr
			end
			if fd ~= s then
				if typeof(fd) == t.p then
					fd = e(fd, fd, fd)
				end
				fv[t.aY] = fd
			end
			return es
		end
		return fW
	end
	D[18] = function()
		local a2 = w
		local as = x
		local G = E(2)
		local bo = E(5)
		local bn = E(6)
		local function dF()
			local bw, bD, dG = bo[t.gH]({ [t.cs] = t.ec, [t.cu] = bn[t.O], [t.dm] = 90 })
			local bx = bw:WaitForChild(t.aR)
			local bH = k(t.dT)
			bH.Name = t.aY
			bH[t.aY] = e(0, 0, 0)
			bH[t.fu] = bw
			local fm = k(t.dT)
			fm.Name = t.dy
			fm[t.aY] = e(0, 0, 0)
			fm[t.fu] = bw
			local bT = k(t.dT)
			bT.Name = "Min"
			bT[t.aY] = e(-a, -a, -a)
			bT[t.fu] = bw
			local bU = k(t.dT)
			bU.Name = "Max"
			bU[t.aY] = e(a, a, a)
			bU[t.fu] = bw
			local fn = k(t.dT)
			fn.Name = t.dB
			fn[t.aY] = e(G[t.eN], G[t.eN], G[t.eN])
			fn[t.fu] = bw
			local fo = k(t.dT)
			fo.Name = t.dC
			fo[t.aY] = e(G[t.eO], G[t.eO], G[t.eO])
			fo[t.fu] = bw
			local function fP(fQ, b2)
				local H = {}
				local ck = bo[t.gg]()
				ck.Name = fQ
				ck[t.fS] = 1
				ck[t.cN] = b2
				ck.Size = h(1, 0, 0.333, -1)
				ck[t.fu] = bD
				local cS = bo[t.go]()
				cS.Size = h(0, 10, 1, 0)
				cS.Text = fQ:lower()
				cS[t.gv] = bn[t.V]
				cS[t.gD] = i[t.gD][t.gG]
				cS[t.fu] = ck
				local f9 = bo[t.gg]()
				f9.Name = t.dn
				f9[t.fS] = 1
				f9[t.cN] = h(0.66, 3, 0, 3)
				f9.Size = h(0.33, -2, 1, -6)
				f9[t.fu] = ck
				local fR = k(t.bE)
				fR.Name = t.dC
				fR[t.aY] = G[t.eO]
				local dM = G[t.eU](fR)
				local dN, bI, fD, fE, fF = bo[t.gJ]({
					[t.cu] = bn[t.O],
					[t.dD] = dM,
					[t.aR] = bx,
					[t.dE] = function(bF, P)
						if o(bF) == 0 then
							return "0"
						else
							local bF = m(bF)
							if bF == s then
								return P[t.aY]
							else
								return dM(bF)
							end
						end
					end,
				})
				bI[t.fu] = f9
				local fG = bo[t.gg]()
				fG.Name = t.eg
				fG[t.fS] = 1
				fG[t.cN] = h(0, 12, 0, 3)
				fG.Size = h(0.66, -12, 1, -6)
				fG[t.fu] = ck
				local fH, fI, bT, bU, bV, fJ, fK, fL = bo[t.gT]({ [t.aR] = bx })
				fH[t.fu] = fG
				local fM = q
				l[t.fg](
					H,
					fD:Connect(function()
						fM = r
					end)
				)
				l[t.fg](
					H,
					fE:Connect(function()
						fM = q
					end)
				)
				l[t.fg](
					H,
					fo[t.gI]:Connect(function()
						fR[t.aY] = fo[t.aY][fQ]
					end)
				)
				l[t.fg](
					H,
					fI[t.gI]:connect(function()
						dN[t.aY] = tostring(fI[t.aY])
					end)
				)
				l[t.fg](
					H,
					dN[t.gI]:connect(function()
						if fM then
							fI[t.aY] = m(dN[t.aY])
						end
					end)
				)
				return dN, fI, bT, bU, dM, G[t.eQ](H, fF, fL)
			end
			local H = {}
			local fS = {}
			for aa, fQ in p(G.AXES) do
				local ac = (aa - 1) * 0.333
				local dN, fI, g1, g2, dM, dO = fP(fQ, h(0, 0, ac, 0))
				fS[fQ] = { [t.eh] = dN, [t.ei] = fI, [t.ej] = g1, [t.ek] = g2, [t.el] = dM, [t.em] = dO }
				l[t.fg](
					H,
					fI[t.gI]:connect(function()
						local P = bH[t.aY]
						local fU = { X = P.X, Y = P.Y, Z = P.Z }
						fU[fQ] = m(fI[t.aY])
						bH[t.aY] = e(fU.X, fU.Y, fU.Z)
					end)
				)
			end
			l[t.fg](
				H,
				fn[t.gI]:connect(function()
					fo[t.aY] = e(G[t.eS](fn[t.aY].X), G[t.eS](fn[t.aY].Y), G[t.eS](fn[t.aY].Z))
					for J, fQ in p(G.AXES) do
						local dN = fS[fQ][t.eh]
						local fV = dN[t.aY]
						if fV == s then
							fV = ""
						end
						dN[t.aY] = "0" .. fV
					end
				end)
			)
			l[t.fg](
				H,
				bT[t.gI]:connect(function()
					for J, fQ in p(G.AXES) do
						fS[fQ][t.ej][t.aY] = bT[t.aY][fQ]
					end
				end)
			)
			l[t.fg](
				H,
				bU[t.gI]:connect(function()
					for J, fQ in p(G.AXES) do
						fS[fQ][t.ek][t.aY] = bU[t.aY][fQ]
					end
				end)
			)
			l[t.fg](
				H,
				fm[t.gI]:connect(function()
					for J, fQ in p(G.AXES) do
						local P = math[t.gY](fm[t.aY][fQ], bT[t.aY][fQ], bU[t.aY][fQ])
						local fd = fn[t.aY][fQ]
						if P % fd ~= 0 then
							P = math[t.eZ](P / fd) * fd
						end
						fS[fQ][t.ei][t.aY] = P
					end
				end)
			)
			return bw, bH, fm, bT, bU, fn, G[t.eQ](H, dG, fS.X[t.em], fS.Y[t.em], fS.Z[t.em])
		end
		local function g3(ej, ek, el, fq, fr, fd, fX)
			local bs, fO, fw, ft, fu, fv, en = dF()
			bs[t.fu] = ej[t.bP]
			local ep = bs:WaitForChild(t.aR)
			local eq
			local er
			local es = { frame = bs, height = bs[t.gX].Y }
			fO[t.gI]:connect(function()
				if not ep[t.aY] then
					if fX then
						ek[el][t.aY] = fO[t.aY]
					else
						ek[el] = fO[t.aY]
					end
				end
				if eq ~= s then
					eq(es[t.hN]())
				end
			end)
			es[t.hO] = function(et)
				eq = et
				return es
			end
			es[t.hP] = function(P)
				if typeof(P) == t.p then
					P = e(P, P, P)
				end
				fw[t.aY] = P
				return es
			end
			es[t.hN] = function()
				if fX then
					return ek[el][t.aY]
				else
					return ek[el]
				end
			end
			es.min = function(fq)
				if typeof(fq) == t.p then
					fq = e(fq, fq, fq)
				end
				ft[t.aY] = fq
				return es
			end
			es.max = function(fr)
				if typeof(fr) == t.p then
					fr = e(fr, fr, fr)
				end
				fu[t.aY] = fr
				return es
			end
			es.step = function(fd)
				if typeof(fd) == t.p then
					fd = e(fd, fd, fd)
				end
				fv[t.aY] = fd
				return es
			end
			es[t.cf] = function()
				if es[t.hQ] then
					return
				end
				en()
				if er ~= s then
					er:Disconnect()
				end
				es[t.hQ] = r
				ej[t.hR](es)
				if es[t.ce] ~= s then
					es[t.ce][t.fu] = s
					es[t.ce] = s
				end
			end
			es[t.hS] = function()
				if er ~= s then
					return
				end
				if fX then
					er = ek[el][t.gI]:Connect(function(P)
						es[t.hP](ek[el][t.aY])
					end)
				else
					local fZ = ek[el].X
					local f_ = ek[el].Y
					local g0 = ek[el].Z
					er = a2[t.fb]:Connect(function(fd)
						local P = ek[el]
						if P.X ~= fZ or P.Y ~= f_ or P.Z ~= g0 then
							fZ = P.X
							f_ = P.Y
							g0 = P.Z
							es[t.hP](ek[el])
						end
					end)
				end
				return es
			end
			es[t.hP](es[t.hN]())
			if fq ~= s then
				if typeof(fq) == t.p then
					fq = e(fq, fq, fq)
				end
				ft[t.aY] = fq
			end
			if fr ~= s then
				if typeof(fr) == t.p then
					fr = e(fr, fr, fr)
				end
				fu[t.aY] = fr
			end
			if fd ~= s then
				if typeof(fd) == t.p then
					fd = e(fd, fd, fd)
				end
				fv[t.aY] = fd
			end
			return es
		end
		return g3
	end
	do
		local cM = E(1)
		local c3 = E(4)
		local ce = E(8)
		local bo = E(5)
		local aw = E(7)
		local bn = E(6)
		local ei = E(9)
		local eU = E(10)
		local fa = E(11)
		local fg = E(12)
		local fj = E(13)
		local fp = E(14)
		local fy = E(15)
		local fN = E(16)
		local fW = E(17)
		local g3 = E(18)
		local g4 = {}
		g4[t.gZ] = g4
		g4.Lib = { Panel = cM, Popover = c3, Scrollbar = ce, GUIUtils = bo, GuiEvents = aw, Constants = bn }
		local function g5(ej, es, el)
			l[t.fg](ej[t.ey], es)
			local bs = es[t.ce]
			bs.Name = el
			es.name = el
			local g6 = bs:WaitForChild(t.aO)
			local g7 = bs:WaitForChild(t.aS)
			local g8 = k(t.bd)
			local g9
			es[t.ib] = function(aH)
				if g9 == s then
					g9 = es[t.cf]
					es[t.cf] = function()
						if es[t.hQ] then
							return
						end
						g8:Fire()
						g9()
					end
				end
				return g8[t.gS]:Connect(aH)
			end
			es[t.ig] = function(cp)
				g7[t.aY] = cp ~= q
				return es
			end
			if type(es.name) ~= t.e then
				local fA = bs:WaitForChild(t.aU)
				fA[t.aY] = el
				es.name = function(fk)
					fA[t.aY] = fk
					return es
				end
			end
			local ga
			local gb
			local gc
			es.help = function(bF)
				if ga == s then
					ga = c3.new(bs, f(200, 60), t.bv, 3)
					ga[t.aM][t.hu] = bn[t.C]
					ga[t.aM][t.fT] = 1
					ga[t.aM][t.fS] = 0
					local gd = bo[t.gg]()
					gd.Name = t.bP
					gd.Size = h(1, 0, 1, 0)
					gd[t.hl] = r
					gd[t.fu] = ga[t.aM]
					local ge = bo[t.gg]()
					ge.Name = t.er
					ge[t.fu] = gd
					gc = bo[t.go]()
					gc.Name = t.cc
					gc[t.gv] = bn[t.O]
					gc.Size = h(1, -6, 0, 16)
					gc[t.cN] = h(0, 3, 0, 0)
					gc[t.fu] = ge
					gb = bo[t.go]()
					gb.Name = t.es
					gb[t.gC] = r
					gb[t.gu] = r
					gb.Size = h(1, -6, 1, 0)
					gb[t.cN] = h(0, 3, 0, 16)
					gb[t.fu] = ge
					local eB = ce.new(gd, ge, 0)
					local eI = q
					local gf = q
					local function gg()
						if gf or eI then
							ge.Size = h(1, 0, 0, gb[t.hv].Y + 16)
							gb.Size = h(1, 0, 1, -16)
							gc.Text = g6.Text
							eB:update()
							ga:show(r, bn[t.E])
						else
							ga:hide()
						end
					end
					local gh = aw[t.fH](bs, function(bS)
						gf = bS
						gg()
					end)
					local gh = aw[t.fI](ga[t.aM], function(bS)
						eI = bS
						gg()
					end)
					es[t.ib](function()
						gh()
						eB:destroy()
						ga:destroy()
					end)
				end
				gb.Text = bF
				return es
			end
			bs[t.gh] = bn[t.z]
			local gi = aw[t.fI](bs, function(bS)
				if bS then
					bs[t.gh] = bn[t.A]
				else
					bs[t.gh] = bn[t.z]
				end
			end)
			es[t.ib](function()
				gi()
			end)
			local bx = bs:WaitForChild(t.aR)
			bx[t.gI]:Connect(function(gj)
				if g6 ~= s then
					if gj then
						local gk = k(t.aM)
						gk.Size = h(0, g6[t.hv].X, 0, 1)
						gk[t.cN] = h(0, 0, 0.5, 0)
						gk[t.gh] = bn[t.F]
						gk[t.fS] = 0.4
						gk[t.fT] = 0
						gk.Name = t.et
						gk[t.fu] = g6
						g6[t.gv] = bn[t.F]
					else
						g6[t.gv] = bn[t.E]
						if g6:FindFirstChild(t.et) ~= s then
							g6:FindFirstChild(t.et)[t.fu] = s
						end
					end
				end
			end)
			es[t.ii] = function(P)
				if P == s then
					P = r
				end
				bx[t.aY] = P
				return es
			end
			return es
		end
		g4.new = function(br)
			if br == s then
				br = {}
			end
			local fk = br.name
			if fk == s or fk == "" then
				fk = t.u
			end
			local ej = { [t.ev] = fk, [t.ew] = r, [t.ex] = br[t.ex], [t.ey] = {} }
			local da = br[t.ij]
			if da == s or da < cM[t.hk] then
				da = cM[t.hk]
			end
			local cT = cM.new()
			ej[t.bO] = cT
			ej[t.bP] = cT[t.bP]
			cT[t.aU][t.aY] = ej[t.ev]
			local gl = k(t.bd)
			local gm = cT:onDestroy(function()
				ej[t.cf]()
			end)
			if ej[t.ex] == s then
				cT:detach(br[t.ik])
				cT:move(bn[t.x][t.gX].X - (da + 15), 0)
				cT:resize(da, bn[t.x][t.gX].Y)
				cT[t.aM].Name = ej[t.ev]
			else
				cT[t.aM].Name = ej[t.ex][t.ev] .. "_" .. ej[t.ev]
				cT:attachTo(ej[t.ex][t.bP], br[t.il])
			end
			ej.add = function(ek, el, ...)
				if ek[el] == s then
					error(t.eA .. el)
				end
				local es
				local gn = ek[el]
				local go = type(gn)
				local gp = typeof(gn)
				local gq = gp == t.eB
				local ah = { ... }
				if gp == t.eC or gq and gn:IsA(t.dT) then
					local fq = ah[1]
					local fr = ah[2]
					local fd = ah[3]
					local fX = gq and gn:IsA(t.dT)
					if fq ~= s and fr ~= s then
						es = g3(ej, ek, el, fq, fr, fd, fX)
					else
						es = fW(ej, ek, el, fq, fr, fd, fX)
					end
				elseif gp == t.eD or gq and gn:IsA(t.cv) then
					es = ei(ej, ek, el, gq and gn:IsA(t.cv))
				elseif gp == t.dg or ah[1] ~= s and typeof(ah[1]) == t.dh then
					es = eU(ej, ek, el, ah[1])
				elseif ah[1] ~= s and type(ah[1]) == t.dd then
					es = eU(ej, ek, el, ah[1])
				elseif gp == t.p or gq and gn:IsA(t.be) then
					local fq = ah[1]
					local fr = ah[2]
					local fd = ah[3]
					local fs = gq and gn:IsA(t.be)
					if fq ~= s and fr ~= s and type(fq) == t.p and type(fr) == t.p then
						es = fN(ej, ek, el, fq, fr, fd, fs)
					else
						es = fp(ej, ek, el, fq, fr, fd, fs)
					end
				elseif gp == t.eE or gq and gn:IsA(t.aQ) then
					es = fg(ej, ek, el, gq and gn:IsA(t.aQ))
				elseif gp == t.di or gq and gn:IsA(t.aT) then
					local f7 = ah[1] == r
					es = fa(ej, ek, el, f7, gq and gn:IsA(t.aT))
				elseif type(gn) == t.e then
					es = fy(ej, ek, el, ah[1])
				end
				if es == s then
					return error(t.eF)
				end
				return g5(ej, es, el)
			end
			ej[t._in] = function(fk, bv)
				return g5(ej, fj(ej, fk, bv), fk)
			end
			ej[t.io] = function(gr, db)
				local bs = k(t.aM)
				bs[t.fT] = 0
				bs[t.fS] = 1
				local bp = bo[t.fQ](gr)
				bp.Name = t.eG
				bp[t.cN] = h(0, 0, 0, 0)
				bp.Size = h(1, 0, 1, 0)
				bp[t.gd] = i[t.gd].Fit
				bp[t.fu] = bs
				local es = ej[t._in](gr, { frame = bs, height = db })
				es[t.ig](q)
				return es
			end
			ej[t.iq] = function(fk, br)
				if br == s then
					br = {}
				end
				br.name = fk
				br[t.ex] = ej
				local gs = g4.new(br)
				l[t.fg](ej[t.ey], gs)
				return gs
			end
			ej[t.ib] = function(aH)
				return gl[t.gS]:Connect(aH)
			end
			ej[t.cf] = function()
				if ej == s or ej[t.hQ] then
					return
				end
				for eP = l.getn(ej[t.ey]), 1, -1 do
					ej[t.ey][eP][t.cf]()
				end
				if ej[t.ex] ~= s then
					ej[t.hQ] = r
					ej[t.ex][t.hR](ej)
				end
				gm:Disconnect()
				ej[t.bO]:destroy()
				ej = s
				gl:Fire()
			end
			ej[t.hR] = function(eN)
				if eN[t.is] == r then
					return
				end
				local gt = -1
				for eP = 1, #ej[t.ey] do
					local cV = ej[t.ey][eP]
					if cV == eN then
						cV[t.is] = r
						cV[t.cf]()
						gt = eP
						break
					end
				end
				if gt > 0 then
					l[t.cf](ej[t.ey], gt)
				end
				return ej
			end
			ej.open = function()
				ej[t.bO][t.bR][t.aY] = q
				return ej
			end
			ej[t.iu] = function()
				ej[t.bO][t.bR][t.aY] = r
				return ej
			end
			ej[t.iv] = function(da, db)
				ej[t.bO]:resize(da, db)
				return ej
			end
			ej.move = function(du, dv)
				ej[t.bO]:move(du, dv)
				return ej
			end
			ej.name = function(fk)
				cT[t.aU][t.aY] = fk
				return ej
			end
			ej[t.ix] = function(bv)
				return cT:addAction(bv)
			end
			if br[t.iy] == r then
				ej[t.iu]()
			end
			return ej
		end
		return g4
	end
end