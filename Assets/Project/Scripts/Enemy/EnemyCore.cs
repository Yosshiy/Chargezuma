using UnityEngine;

namespace Chargezuma.Enemy
{
    /// <summary>
    /// エネミーの基底クラス
    /// </summary>
    public abstract class EnemyCore : MonoBehaviour
    {
        /// <summary>
        /// 当たった時の処理 : Trigger
        /// </summary>
        protected virtual void OnTriggerEnter(Collider other)
        {
            PlayAction();
        }

        /// <summary>
        /// 当たった時の処理 : Collision
        /// </summary>
        protected virtual void OnCollisionEnter(Collision collision)
        {
            PlayAction();
        }

        /// <summary>
        /// エネミーに当たった時の処理
        /// </summary>
        protected abstract void PlayAction();

    }
}
