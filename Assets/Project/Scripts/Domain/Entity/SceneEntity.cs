using Cysharp.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using UnityEngine.SceneManagement;

namespace Chargezuma.Domain.Entity
{
    /// <summary>
    /// シーン関連の処理を記述するスクリプト
    /// </summary>
    public class SceneEntity : ISceneEntity
    {
        //全てのシーンに常駐するシーン名
        const string MASTERSCENE = "Main";
        //最初に遷移するシーン名
        const string FIRSTSCENE = "Title";

        public SceneEntity()
        {
            Initialize();
        }

        /// <summary>
        /// 初期化
        /// </summary>
        void Initialize()
        {
            var scene = SceneManager.GetActiveScene().name;

            if (scene == MASTERSCENE)
            {
                SceneManager.LoadSceneAsync(FIRSTSCENE, LoadSceneMode.Additive);
            }
            else
            {
                SceneManager.LoadSceneAsync(MASTERSCENE);
                SceneManager.LoadSceneAsync(FIRSTSCENE, LoadSceneMode.Additive);
            }
        }

        /// <summary>
        /// 現在のシーンをリロード
        /// </summary>
        public async UniTask Reload(string name)
        {
            Scene oldscene = SceneManager.GetSceneByName(name);
            await SceneLoad(oldscene.name);
        }

        /// <summary>
        /// 非同期でのシーンのロード
        /// 基本的にUnityのSceneManagerのラッパー
        /// </summary>
        public async UniTask SceneLoad(string name)
        {
            await SceneManager.LoadSceneAsync(name, LoadSceneMode.Additive);
            await SceneManager.UnloadSceneAsync(GetOldScene());
        }

        /// <summary>
        /// 破棄するためのシーンを取得
        /// </summary>
        private Scene GetOldScene()
        {
            List<Scene> old = new List<Scene>();

            for (int i = 0; i < SceneManager.sceneCount; i++)
            {
                old.Add(SceneManager.GetSceneAt(i));
            }

            return old.Where(x => x.name != MASTERSCENE).First();
        }
    }
}