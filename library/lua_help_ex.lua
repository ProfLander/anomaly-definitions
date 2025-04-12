---@meta

---Additional keybinds
key_bindings.kSAFEMODE = 92
key_bindings.kFREELOOK = 93

---@param bone? number|string defaults to root bone if nil
---@param bHud? boolean set `true` if `game_object` is a hud item - defaults to false
---@return vector
function game_object:bone_position(bone, bHud)  end

---Returns angle vector of a bone in the `game_object`.
---
---Rotations are given in the order: Heading, Pitch, and Bank - that is, YXZ.
---So the X and Y components should be swapped if you want to match `se_obj.angle`
---
---@param bone? number|string defaults to root bone if nil
---@param bHud? boolean set `true` if `game_object` is a hud item - defaults to false
---@return vector
function game_object:bone_direction(bone, bHud) end

---@param bHud boolean
---@return table<number, string>
function game_object:list_bones(bHud) end

-- Additional exports from Modded Exes: https://github.com/themrdemonized/xray-monolith
--[[
    lua extensions {
        bit.tobit(int)
        bit.tohex(int)
        bit.bnot(int)
        bit.band(int, int)
        bit.bor(int, int)
        bit.bxor(int, int)
        bit.lshift(int, int)
        bit.rshift(int, int)
        bit.rol(int, int)
        bit.ror(int, int)

        string.trim(s)
        string.trim_l(s)
        string.trim_r(s)
        string.trim_w(s)

        table.keys(t)
        table.values(t)
        table.size(t)
        table.random(t)
    }

    globals {
        int get_modded_exes_version() // Returns modded exes version in integer format
        table get_string_table() // Returns all translated strings in [string id] = string text format 
    }

    namespace alife() {
        void iterate_objects(function(se_obj))
    }

    namespace game {
        Fvector2 world2ui(Fvector pos, bool hud = false, bool allow_offscreen = false)
        function ui2world(Fvector2 pos) -> Fvector result, u16 object_id
        change_game_news_show_time(CUIWindow* UIWindow, float show_time)
        update_pda_news_from_uiwindow(CUIWindow* UIWindow)
    }

    ini_file() {
        string get_filename()
        void dltx_print(string sec = nil, string line = nil)
        string dltx_get_filename_of_line(string sec, string line)
        table dltx_get_section(string sec)
        bool dltx_is_override(string sec, string line)
    }

    // UI hud
    // get_hud():GetWindow()
    get_hud() {
        CUIWindow GetWindow()
    }

    // Player hud
    // get_player_hud():set_hands("actor_hud_cs_exo")
    globals {
        player_hud* get_player_hud()
    }
    player_hud {
        void set_hands(string section)
        void reset_hands()
    }

    // Debug shapes
    enum DebugRenderType {
        line,
        sphere,
        box,
    }
    namespace debug_render {
        DBG_ScriptObject* add_object(u16 id, DebugRenderType type)
        void remove_object(u16 id)
        DBG_ScriptObject* get_object(u16 id)
        u32 get_flags()
        void set_flags(u32 flags)
        DBG_ScriptSphere* cast_dbg_sphere()
        DBG_ScriptBox* cast_dbg_box()
        DBG_ScriptLine* cast_dbg_line()

        // Common properties
        fcolor color
        bool hud
        bool visible
    }
    class DBG_ScriptSphere {
        Fmatrix matrix
    }
    class DBG_ScriptBox {
        Fmatrix matrix
        Fvector size
    }
    class DBG_ScriptLine {
        Fvector point_a
        Fvector point_b
    }
    // examples
        local sphere = debug_render.add_object(1337, DBG_ScriptObject.sphere):cast_dbg_sphere()
        sphere.visible = true
        sphere.color = fcolor():set(1,0,0,1)
        local scale_mat = matrix():identity():scale(0.1,0.1,0.1)
        local pos_mat = matrix():translate(db.actor:position())
        local mat = matrix():mul(pos_mat, scale_mat)
        sphere.matrix = mat

        local line = debug_render.add_object(9, DBG_ScriptObject.line):cast_dbg_line()
        line.point_a = db.actor:position()
        line.point_b = vector():set(0, 0, 0)
        
        local box = debug_render.add_object(12, DBG_ScriptObject.box):cast_dbg_box()
        box.size = vector():set(0.5,1,0.5)

    namespace level {
        float get_music_volume()
        void set_music_volume(float)

        // Camera, position is x,y,z vector, direction is head,pitch,roll vector in RADIANS
        void set_cam_custom_position_direction(Fvector position, Fvector direction, int smoothing, bool hudDraw, bool hudAffect)
        void set_cam_custom_position_direction(Fvector position, Fvector direction, int smoothing, bool hudDraw)
        void set_cam_custom_position_direction(Fvector position, Fvector direction, int smoothing)
        void set_cam_custom_position_direction(Fvector position, Fvector direction)
        void remove_cam_custom_position_direction()

        // Get target position and result of crosshair ray_query
        Fvector get_target_pos()
        script_rq_result get_target_result()

        void map_remove_all_object_spots(id)

        CUIStatic* map_get_object_spot_static(u16 id, LPCSTR spot_type)
        CUIStatic* map_get_object_minimap_spot_static(u16 id, LPCSTR spot_type)
        table map_get_object_spots_by_id(u16 id) // Returns array of tables
        // {
            spot_type: string, icon ID from map_spots XML
            text: string, text when spot is hovered
        // }

        add_bullet(Fvector pos, Fvector dir, float speed, float power, float impulse, u16 sender, ALife::EHitType hit_type, float max_dist, LPCSTR ammo_sect, float air_resistance)

        add_bullet(table t)
        // Supported parameters and example:
        //    local t = {
        //        pos = device().cam_pos,
        //        dir = device().cam_dir,
        //        speed = 10,
        //        power = 1,
        //        impulse = 1,
        //        sender = AC_ID,
        //        senderweapon = db.actor:active_item():id(),   // Defaults to what's set for sender if not specified
        //        hit_type = 1,
        //        max_dist = 100,
        //        ammo_sect = "ammo_5.56x45_fmj",
        //        air_resistance = 0.2,
        //    }
        //    level.add_bullet(t)
    }

    // obj:get_physics_shell()
    class PHShell {
        void apply_torque(float roll, float yaw, float pitch)
    }

    class Fvector {
        function add(float x, float y, float z)
        function sub(float x, float y, float z)
        function mul(float x, float y, float z)
        function div(float x, float y, float z)
        function distance_to_xz_sqr(Fvector)
    }

    class Fmatrix {
        property i
        property _14_
        property j
        property _24_
        property k
        property _34_
        property c
        property _44_

        matrix()

        function set(Fmatrix)
        function set(Fvector, Fvector, Fvector, Fvector) 
        function identity()
        function mk_xform(quaternion, Fvector)
        function build_camera_dir(Fvector vFrom, Fvector vView, Fvector vWorldUp)
        function build_projection(float fov, float aspect, float nearPlane, float farPlane)
        function mulA_43(Fmatrix A)
        function mulA_44(Fmatrix A)
        function mulB_43(Fmatrix B)
        function mulB_44(Fmatrix B)
        function mul_43(Fmatrix A, Fmatrix B)
        function translate(float x, float y, float z)
        function translate(Fvector)
        function translate_add(float x, float y, float z)
        function translate_add(Fvector)
        function translate_over(float x, float y, float z)
        function translate_over(Fvector)
        function mul(Fmatrix, Fmatrix)
        function mul(Fmatrix, float)
        function mul(float)
        function invert()
        function invert(Fmatrix)
        function invert_b(Fmatrix)
        function div(Fmatrix, float)
        function div(float)
        function scale(float x, float y, float z)
        function scale(Fvector)
        function setHPB(float x, float y, float z)
        function setHPB(Fvector)
        function setXYZ(float x, float y, float z)
        function setXYZ(Fvector)
        function setXYZi(float x, float y, float z)
        function setXYZi(Fvector)
        Fvector getHPB()
    }

    class particle_object {
        function play(bool bHudMode = false)
        function play_at_pos(Fvector pos, bool bHudMode = false)
    }

    class wallmarks_manager {
        wallmarks_manager()
        function place (Fvector dir, Fvector start_pos, float trace_dist, float wallmark_size, string section, game_object ignore_obj, float ttl)
        function place (Fvector dir, Fvector start_pos, float trace_dist, float wallmark_size, string section, game_object ignore_obj, float ttl, bool random_rotation)

        // User defined rotation in DEGREES
        function place (Fvector dir, Fvector start_pos, float trace_dist, float wallmark_size, string section, game_object ignore_obj, float ttl, float rotation)

        function place_skeleton (game_object obj, string section, Fvector start, Fvector dir, float size, float ttl)
    }

    class game_object {
        // Skeletons
        function bone_direction(string bone_name, bool bHud = false)

        // Player
        function get_actor_walk_accel()
        function set_actor_walk_accel(float)
        function get_actor_walk_back_coef()
        function set_actor_walk_back_coef(float)
        function get_actor_lookout_coef()
        function set_actor_lookout_coef(float)
        function set_actor_direction(float yaw, float pitch)
        function set_actor_direction(float yaw, float pitch, float roll)
        function set_actor_direction(Fvector HPB)
        function get_actor_crouch_coef()
        function set_actor_crouch_coef(float)
        function get_actor_climb_coef()
        function set_actor_climb_coef(float)
        function get_actor_walk_strafe_coef()
        function set_actor_walk_strafe_coef(float)
        function get_actor_run_strafe_coef()
        function set_actor_run_strafe_coef(float)
        function get_actor_sprint_strafe_coef()
        function set_actor_sprint_strafe_coef(float)
        function update_weight()
        function get_total_weight_force_update()
        function get_talking_npc()
        function set_actor_position(vector pos, bool bskip_collision_correct, bool bkeep_speed)
        function set_movement_speed(vector)
        function get_actor_ui_luminocity()
        function get_actor_object_looking_at()
        function get_actor_person_looking_at()
        function get_actor_default_action_for_object()

        // Stalker NPCs
        function get_enable_anomalies_pathfinding()
        function set_enable_anomalies_pathfinding(bool)
        function get_enable_anomalies_damage()
        function set_enable_anomalies_damage(bool)
        function angle()
        function force_set_angle(Fvector angle, bool bActivate)
        function set_enable_movement_collision(bool)
        function character_dialogs()

        // Artefact
        function get_artefact_additional_inventory_weight()
        function set_artefact_additional_inventory_weight(float)

        // Bones
        u16 get_bone_id(string)
        u16 get_bone_id(string, bool bHud)

        u16 bone_id(string) // Same as get_bone_id
        u16 bone_id(string, bool bHud)

        string bone_name(u16 id)
        string bone_name(u16 id, bool bHud)

        Fvector bone_position(u16 id)
        Fvector bone_position(u16 id, bool bHud)
        Fvector bone_position(string)
        Fvector bone_position(string, bool bHud)

        Fvector bone_direction(u16 id)
        Fvector bone_direction(u16 id, bool bHud)
        Fvector bone_direction(string)
        Fvector bone_direction(string, bool bHud)

        u16 bone_parent(u16 id)
        u16 bone_parent(u16 id, bool bHud)
        u16 bone_parent(string)
        u16 bone_parent(string, bool bHud)

        bool bone_visible(u16 id)
        bool bone_visible(u16 id, bool bHud)
        bool bone_visible(string)
        bool bone_visible(string, bool bHud)

        function set_bone_visible(u16 id, bool bVisibility, bool bRecursive, bool bHud)
        function set_bone_visible(string bone_name, bool bVisibility, bool bRecursive, bool bHud)

        function list_bones(bool bHud = false)

        // Torch
        function update_torch()
        
        // Script Attachments
        function add_attachment(number, string);
        function get_attachment(number);
        function remove_attachment(number);
    }

    class CArtefact : CGameObject {
        property m_additional_weight
    }

    class CWeapon : CGameObject {
        // Return RPM in actual RPM value like in configs
        function RealRPM()
        function ModeRealRPM()

        // Setters
        function SetFireDispersion(float)
        function SetMisfireStartCondition(float)
        function SetMisfireEndCondition(float)
        function SetRPM(float)
        function SetRealRPM(float)
        function SetModeRPM(float)
        function SetModeRealRPM(float)
        function Set_PDM_Base(float)
        function Set_Silencer_PDM_Base(float)
        function Set_Scope_PDM_Base(float)
        function Set_Launcher_PDM_Base(float)
        function Set_PDM_BuckShot(float)
        function Set_PDM_Vel_F(float)
        function Set_Silencer_PDM_Vel(float)
        function Set_Scope_PDM_Vel(float)
        function Set_Launcher_PDM_Vel(float)
        function Set_PDM_Accel_F(float)
        function Set_Silencer_PDM_Accel(float)
        function Set_Scope_PDM_Accel(float)
        function Set_Launcher_PDM_Accel(float)
        function Set_PDM_Crouch(float)
        function Set_PDM_Crouch_NA(float)
        function SetCrosshairInertion(float)
        function Set_Silencer_CrosshairInertion(float)
        function Set_Scope_CrosshairInertion(float)
        function Set_Launcher_CrosshairInertion(float)
        function SetFirstBulletDisp(float)
        function SetHitPower(float)
        function SetHitPowerCritical(float)
        function SetHitImpulse(float)
        function SetFireDistance(float)

        // World model on stalkers adjustments
        function Set_mOffset(Fvector position, Fvector orientation)
        function Set_mStrapOffset(Fvector position, Fvector orientation)
        function Set_mFirePoint(Fvector position)
        function Set_mFirePoint2(Fvector position)
        function Set_mShellPoint(Fvector position)        

        // Cam Recoil
        // Getters
        function GetCamRelaxSpeed()
        function GetCamRelaxSpeed_AI()
        function GetCamDispersion()
        function GetCamDispersionInc()
        function GetCamDispersionFrac()
        function GetCamMaxAngleVert()
        function GetCamMaxAngleHorz()
        function GetCamStepAngleHorz()
        function GetZoomCamRelaxSpeed()
        function GetZoomCamRelaxSpeed_AI()
        function GetZoomCamDispersion()
        function GetZoomCamDispersionInc()
        function GetZoomCamDispersionFrac()
        function GetZoomCamMaxAngleVert()
        function GetZoomCamMaxAngleHorz()
        function GetZoomCamStepAngleHorz()

        // Setters
        function SetCamRelaxSpeed(float)
        function SetCamRelaxSpeed_AI(float)
        function SetCamDispersion(float)
        function SetCamDispersionInc(float)
        function SetCamDispersionFrac(float)
        function SetCamMaxAngleVert(float)
        function SetCamMaxAngleHorz(float)
        function SetCamStepAngleHorz(float)
        function SetZoomCamRelaxSpeed(float)
        function SetZoomCamRelaxSpeed_AI(float)
        function SetZoomCamDispersion(float)
        function SetZoomCamDispersionInc(float)
        function SetZoomCamDispersionFrac(float)
        function SetZoomCamMaxAngleVert(float)
        function SetZoomCamMaxAngleHorz(float)
        function SetZoomCamStepAngleHorz(float)

        //Scope UI
        //Returns table containing this data
        {
            name - name of scope_texture weapon currently uses
            uiWindow - CUIWindow instance of scope UI
            statics - array of CUIStatic that CUIWindow scope UI instance uses
        }
        table get_scope_ui() 
        function set_scope_ui(string)
        
        // Get and set the zoom_rotate_time (time in seconds to fully ADS) field for a given weapon
        function GetZoomRotateTime()
        function SetZoomRotateTime(float)
    }

    enum rq_target { (sum them up to target multiple types)
        rqtNone     = 0,
        rqtObject   = 1,
        rqtStatic   = 2,
        rqtShape    = 4,
        rqtObstacle = 8,
    }

    class ray_pick {
        ray_pick()
        ray_pick(Fvector position, Fvector direction, float range, rq_target flags, game_object obj)
        function set_position(Fvector)
        function set_direction(Fvector)
        function set_range(float)
        function set_flags(rq_target)
        function set_ignore_object(game_object)
        function query()
        function get_result() : rq_result
        function get_object() : game_object
        function get_distance() : float
        function get_element() : int (number of triangle)
    }

    class script_rq_result {
        const object
        const range
        const element
        const material_name
        const material_flags
        const material_phfriction
        const material_phdamping
        const material_phspring
        const material_phbounce_start_velocity
        const material_phbouncing
        const material_flotation_factor
        const material_shoot_factor
        const material_shoot_factor_mp
        const material_bounce_damage_factor
        const material_injurious_speed
        const material_vis_transparency_factor
        const material_snd_occlusion_factor
        const material_density_factor
    }

    // Available flags, not exported from engine, copy this into your script
    material_flags = {
        ["flBreakable"]         = bit.lshift(1, 0),
        ["flBounceable"]        = bit.lshift(1, 2),
        ["flSkidmark"]          = bit.lshift(1, 3),
        ["flBloodmark"]         = bit.lshift(1, 4),
        ["flClimable"]          = bit.lshift(1, 5),
        ["flPassable"]          = bit.lshift(1, 7),
        ["flDynamic"]           = bit.lshift(1, 8),
        ["flLiquid"]            = bit.lshift(1, 9),
        ["flSuppressShadows"]   = bit.lshift(1, 10),
        ["flSuppressWallmarks"] = bit.lshift(1, 11),
        ["flActorObstacle"]     = bit.lshift(1, 12),
        ["flNoRicoshet"]        = bit.lshift(1, 13),
        ["flInjurious"]         = bit.lshift(1, 28),
        ["flShootable"]         = bit.lshift(1, 29),
        ["flTransparent"]       = bit.lshift(1, 30),
        ["flSlowDown"]          = bit.lshift(1, 31),
    }
    
    // Child class of script_light - used specifically to attach it to script_attachments
    // set_position and set_direction work as an offset to the parent attachment position/direction
    class attachment_script_light : script_light {
        property color;
        property enabled;
        property hud_mode;
        property lanim;
        property lanim_brightness;
        property range;
        property shadow;
        property texture;
        property type;
        property volumetric;
        property volumetric_distance;
        property volumetric_intensity;
        property volumetric_quality;
        
        attachment_script_light ();
        
        function set_direction(vector);
        function set_direction(vector, vector);
        function set_direction(number, number, number);
        function set_position(vector);
        function set_position(number, number, number);
    }
    
    class ScriptAttachment {
        function add_attachment(number, string);
        function attach_light(attachment_script_light*);
        function bone_callback(number, number, boolean);
        function bone_callback(number, const function<matrix>&, boolean);
        function detach_light();
        function get_attachment(number);
        function get_bone_matrix(number);
        function get_bone_visible(number);
        function get_center();
        function get_flags();
        function get_light();
        function get_model();
        function get_origin();
        function get_parent();
        function get_parent_bone();
        function get_position();
        function get_rotation();
        function get_scale();
        function get_transform();
        function get_ui();
        function get_ui_bone();
        function get_ui_rotation();
        function play_motion(string, boolean, number);
        function remove_attachment(number);
        function remove_bone_callback(number);
        function set_bone_visible(number, boolean);
        function set_flags(number);
        function set_model(string, boolean);
        function set_origin(vector);
        function set_origin(number, number, number);
        function set_parent(ScriptAttachment*);
        function set_parent(game_object*);
        function set_parent_bone(number);
        function set_position(vector);
        function set_position(number, number, number);
        function set_rotation(vector);
        function set_rotation(number, number, number);
        function set_scale(vector);
        function set_scale(number, number, number);
        function set_scale(number);
        function set_ui(string);
        function set_ui_bone(number);
        function set_ui_position(vector);
        function set_ui_position(number, number, number);
        function set_ui_position();
        function set_ui_rotation(vector);
        function set_ui_rotation(number, number, number);
    }
    
    flags:
    ["eSA_RenderHUD"] = 1,
    ["eSA_RenderWorld"] = 2,
    ["eSA_CamAttached"] = 4,
    
    Script Attachment examples:
    
    -- adds script attachment with model gamedata\meshes\test\box.ogf to the actor's current active item in slot 1 (slots range from 0 to 65535)
    local att = db.actor:active_item():add_attachment(1, "test\\box")
    
    -- setting attachment parameters
    
    -- functions accept both vectors or three values, scale even accepts one value
    att:set_position(0,1,2)
    att:set_rotation(vector():set(0,90,0))
    att:set_scale(0.9)
    
    -- render both on hud and world model (default is 2 -> only on world model)
    att:set_flags(3)
    
    -- create an attachment_script_light (can use script_light functions and properties)
    -- ! make sure to keep a reference to the script light or it will be garbage collected !
    att_light = attachment_script_light()
    att_light.type = 2
    att_light.hud_mode = true
    
    -- attachment_script_light position and direction work as an offset to the attachment position/direction
    att_light:set_position(0,0,2)
    att_light:set_direction(0,90,0)
    att_light:set_cone(math.rad(0.5))
    att_light.color = fcolor():set(1,0,0,1)
    
    -- attach it to the script attachment
    att:attach_light(att_light)
    
    
    -- attach the model to the actor instead of their active item
    att:set_parent(db.actor)
    
    -- make it a camera attachment
    att:set_flags(4)
    
    -- you can attach attachments to other attachments
    att2 = att:add_attachment(0, "test\\box2")
    att3 = att2:add_attachment(0, "test\\box2")
    
    -- and transfer the whole chain of attachments to another parent
    -- this will transfer att and its child attachments to the new parent
    att:set_parent(db.actor:active_item())
    
    -- same for child attachments
    att3:set_parent(npc)
    
    -- it's also possible to change the model at any time
    -- the boolean tells the engine if existing bone callbacks should be kept in place or if they should be removed
    att3:set_model("armor\\boots", false)
    
    -- bone callbacks can be added like this
    -- there are two types of bone callbacks
    -- this makes the bone 1 of the attachment model follow the position of bone 6 of its parent object, the boolean tells the engine to overwrite any animation positions
    -- same with bone 2 of the attachment model to bone 10 of the parent object
    att3:bone_callback(1, 6, false)
    att3:bone_callback(2, 10, false)
    
    -- the second type of bone callbacks uses a script callback to change the position of a bone in real time
    local lock = db.actor:add_attachment(1234, "interface\\lockpick\\lock3")
    lock:set_flags(4)
    lock:set_rotation(90,0,0)
    lock:set_position(0,0,0.09)
    -- the callback function "cylinder_callback" will be used to adjust the position of bone 1
    lock:bone_callback(1, cylinder_callback, false)
    
    -- example callback function
    -- this will adjust the rotation of the bone
    function cylinder_callback(mat)
        local temp = mat.c
        local hpb = mat:getHPB()
        mat:setHPB(hpb.x, hpb.y + cylinder_rotation, hpb.z)
        mat.c = temp
        return mat
    end
--]]

