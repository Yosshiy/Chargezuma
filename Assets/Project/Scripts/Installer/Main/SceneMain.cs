using UnityEngine;
using Zenject;
using Chargezuma.Domain.Entity;
using Chargezuma.View.Output;

namespace Chargezuma.Installer
{
    /// <summary>
    /// アダプタークラスの生成、コンテナへの代入
    /// </summary>
    public class SceneMain : MonoBehaviour
    {
        [SerializeField] SceneAnimation Output;
        ISceneAdaptor Adaptor;
        [Inject]
        ISceneEntity Entity;
        [Inject]
        DiContainer Container;

        /// <summary>
        /// 初期化、代入
        /// </summary>
        private void Awake()
        {
            Adaptor = new SceneAdaptor(Entity, Output);
            Container.Bind<ISceneAdaptor>()
                     .FromInstance(Adaptor)
                     .AsCached();
        }

        /// <summary>
        /// オブジェクト破壊時に解放処理の呼び出し
        /// </summary>
        private void OnDestroy()
        {
            Adaptor.Finish();
        }
    }
}
